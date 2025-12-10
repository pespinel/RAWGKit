//
// GamesViewModel.swift
// RAWGKit
//
// Created by RAWGKit on 10/12/2025.
//

import Combine
import Foundation

/// A SwiftUI-ready ViewModel for managing game lists with search, filters, and pagination.
///
/// `GamesViewModel` provides a complete state management solution for displaying
/// game collections in SwiftUI apps. It handles loading states, error handling,
/// pagination, search, and filtering.
///
/// ## Features
/// - **ObservableObject**: Uses Combine for automatic UI updates (iOS 15+, macOS 13+)
/// - **Pagination**: Automatically loads more games as needed
/// - **Search**: Debounced search with query management
/// - **Filters**: Support for platforms, genres, dates, and ordering
/// - **Error handling**: Structured error states with retry support
/// - **Thread-safe**: All operations are safe to call from main actor
///
/// ## Usage
/// ```swift
/// @StateObject private var viewModel = GamesViewModel(client: rawgClient)
///
/// var body: some View {
///     List {
///         ForEach(viewModel.games) { game in
///             GameRowView(game: game)
///         }
///
///         if viewModel.canLoadMore {
///             ProgressView()
///                 .onAppear { viewModel.loadMore() }
///         }
///     }
///     .searchable(text: $viewModel.searchQuery)
///     .task { await viewModel.loadGames() }
///     .overlay {
///         if case .loading = viewModel.state, viewModel.games.isEmpty {
///             ProgressView()
///         }
///     }
/// }
/// ```
@MainActor
public final class GamesViewModel: ObservableObject {
    // MARK: - State Management

    /// Represents the current loading state of the view model.
    public enum State: Equatable {
        /// Initial state before any data is loaded.
        case idle

        /// Currently loading data from the API.
        case loading

        /// Data successfully loaded and available.
        case loaded

        /// An error occurred during loading.
        case error(NetworkError)

        public static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.loaded, .loaded):
                true
            case let (.error(lhsError), .error(rhsError)):
                lhsError.localizedDescription == rhsError.localizedDescription
            default:
                false
            }
        }
    }

    // MARK: - Public Properties

    /// Current loading/error state.
    @Published public private(set) var state: State = .idle

    /// List of loaded games.
    @Published public private(set) var games: [Game] = []

    /// Search query for filtering games.
    @Published public var searchQuery: String = "" {
        didSet {
            if searchQuery != oldValue {
                scheduleSearch()
            }
        }
    }

    /// Selected platform IDs for filtering.
    @Published public var platformIDs: [Int] = [] {
        didSet {
            if platformIDs != oldValue {
                Task { await reloadGames() }
            }
        }
    }

    /// Selected genre IDs for filtering.
    @Published public var genreIDs: [Int] = [] {
        didSet {
            if genreIDs != oldValue {
                Task { await reloadGames() }
            }
        }
    }

    /// Ordering preference (e.g., "-added", "-rating", "-released").
    @Published public var ordering: String? {
        didSet {
            if ordering != oldValue {
                Task { await reloadGames() }
            }
        }
    }

    /// Whether more games can be loaded.
    public var canLoadMore: Bool {
        hasMorePages && state != .loading
    }

    // MARK: - Private Properties

    private let client: RAWGClient
    private var currentPage = 1
    private var hasMorePages = true
    private var searchTask: Task<Void, Never>?

    // MARK: - Initialization

    /// Creates a new games view model.
    ///
    /// - Parameter client: The RAWGClient instance for API calls.
    public init(client: RAWGClient) {
        self.client = client
    }

    // MARK: - Public Methods

    /// Loads the first page of games based on current filters.
    ///
    /// This method resets pagination and loads fresh data. Call this when
    /// first displaying the view or after changing filters.
    public func loadGames() async {
        currentPage = 1
        hasMorePages = true
        games = []
        await fetchGames()
    }

    /// Reloads games by resetting state and fetching again.
    ///
    /// Use this when filters change to get fresh results.
    public func reloadGames() async {
        await loadGames()
    }

    /// Loads the next page of games.
    ///
    /// Call this when the user scrolls near the end of the list.
    /// Does nothing if already loading or no more pages available.
    public func loadMore() {
        guard canLoadMore else { return }

        Task {
            currentPage += 1
            await fetchGames()
        }
    }

    /// Retries the last failed request.
    ///
    /// Call this from an error state to attempt loading again.
    public func retry() async {
        await fetchGames()
    }

    // MARK: - Private Methods

    private func fetchGames() async {
        state = .loading

        do {
            let response = try await client.fetchGames(
                page: currentPage,
                pageSize: 20,
                search: searchQuery.isEmpty ? nil : searchQuery,
                ordering: ordering,
                platforms: platformIDs.isEmpty ? nil : platformIDs,
                genres: genreIDs.isEmpty ? nil : genreIDs
            )

            if currentPage == 1 {
                games = response.results
            } else {
                games.append(contentsOf: response.results)
            }

            hasMorePages = response.next != nil
            state = .loaded
        } catch let error as NetworkError {
            state = .error(error)
        } catch {
            state = .error(.unknown(error))
        }
    }

    private func scheduleSearch() {
        searchTask?.cancel()

        searchTask = Task {
            // Debounce: wait 300ms before searching
            try? await Task.sleep(for: .milliseconds(300))

            guard !Task.isCancelled else { return }
            await reloadGames()
        }
    }
}
