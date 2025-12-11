//
// ContentView.swift
// RAWGKit Example
//
// SwiftUI example demonstrating RAWGKit's SwiftUI-first components and view models.
//

import RAWGKit
import SwiftUI

extension GamesViewModel.State {
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}

@available(iOS 15.0, macOS 13.0, *)
struct ContentView: View {
    @StateObject private var viewModel: GamesViewModel
    @State private var showingFilters = false

    init(viewModel: GamesViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? GamesViewModel(
            client: RAWGClient(apiKey: Configuration.apiKey)
        ))
    }

    var body: some View {
        NavigationView {
            ZStack {
                gamesList

                if viewModel.state == .loading, viewModel.games.isEmpty {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchQuery, prompt: "Search games...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingFilters.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FiltersView(viewModel: viewModel)
            }
            .alert("Error", isPresented: .constant(viewModel.state.isError)) {
                Button("Retry") {
                    Task { await viewModel.retry() }
                }
                Button("OK", role: .cancel) {}
            } message: {
                if case let .error(error) = viewModel.state {
                    Text(error.localizedDescription)
                }
            }
            .task {
                if viewModel.games.isEmpty {
                    await viewModel.loadGames()
                }
            }
        }
    }

    @ViewBuilder
    private var gamesList: some View {
        if viewModel.games.isEmpty, viewModel.state != .loading {
            VStack(spacing: 16) {
                Image(systemName: "gamecontroller")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                Text("No Games Found")
                    .font(.headline)
                Text("Try adjusting your search or filters")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        } else {
            List {
                ForEach(viewModel.games) { game in
                    GameRowView(game: game)
                        .onAppear {
                            if game == viewModel.games.last {
                                Task {
                                    viewModel.loadMore()
                                }
                            }
                        }
                }

                if viewModel.canLoadMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.reloadGames()
            }
        }
    }
}

// MARK: - Filters View

@available(iOS 15.0, macOS 13.0, *)
struct FiltersView: View {
    @ObservedObject var viewModel: GamesViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPlatforms: Set<Int> = []
    @State private var selectedGenres: Set<Int> = []
    @State private var selectedOrdering: GameOrdering = .releasedDescending

    var body: some View {
        NavigationView {
            Form {
                Section("Platforms") {
                    ForEach(popularPlatforms, id: \.id) { platform in
                        Toggle(platform.name, isOn: Binding(
                            get: { selectedPlatforms.contains(platform.id) },
                            set: { isOn in
                                if isOn {
                                    selectedPlatforms.insert(platform.id)
                                } else {
                                    selectedPlatforms.remove(platform.id)
                                }
                            }
                        ))
                    }
                }

                Section("Genres") {
                    ForEach(popularGenres, id: \.id) { genre in
                        Toggle(genre.name, isOn: Binding(
                            get: { selectedGenres.contains(genre.id) },
                            set: { isOn in
                                if isOn {
                                    selectedGenres.insert(genre.id)
                                } else {
                                    selectedGenres.remove(genre.id)
                                }
                            }
                        ))
                    }
                }

                Section("Sort By") {
                    Picker("Ordering", selection: $selectedOrdering) {
                        Text("Release Date").tag(GameOrdering.releasedDescending)
                        Text("Name").tag(GameOrdering.name)
                        Text("Rating").tag(GameOrdering.ratingDescending)
                        Text("Metacritic").tag(GameOrdering.metacriticDescending)
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedPlatforms.removeAll()
                        selectedGenres.removeAll()
                        selectedOrdering = .releasedDescending
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.platformIDs = Array(selectedPlatforms)
                        viewModel.genreIDs = Array(selectedGenres)
                        viewModel.ordering = selectedOrdering.rawValue
                        Task {
                            await viewModel.reloadGames()
                        }
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedPlatforms = Set(viewModel.platformIDs)
                selectedGenres = Set(viewModel.genreIDs)
                if let ordering = viewModel.ordering,
                   let gameOrdering = GameOrdering(rawValue: ordering) {
                    selectedOrdering = gameOrdering
                }
            }
        }
    }

    private let popularPlatforms = [
        Platform.Popular.pc,
        Platform.Popular.playStation5,
        Platform.Popular.playStation4,
        Platform.Popular.xboxOne,
        Platform.Popular.xboxSeriesXS,
        Platform.Popular.nintendoSwitch,
    ]

    private let popularGenres = [
        Genre.Popular.action,
        Genre.Popular.adventure,
        Genre.Popular.rpg,
        Genre.Popular.shooter,
        Genre.Popular.strategy,
        Genre.Popular.simulation,
        Genre.Popular.puzzle,
        Genre.Popular.sports,
    ]
}

// MARK: - Preview

#Preview("ContentView") {
    if #available(iOS 15.0, macOS 13.0, *) {
        // Try to use real configuration, fallback to placeholder for preview
        let apiKey = Configuration.apiKeyIfAvailable ?? "preview-placeholder"
        let viewModel = GamesViewModel(
            client: RAWGClient(apiKey: apiKey)
        )

        return ContentView(viewModel: viewModel)
    }
}
