//
// PaginatedSequence.swift
// RAWGKit
//

import Foundation

/// Extensions for RAWGClient that provide AsyncSequence pagination
public extension RAWGClient {
    /// Creates an async sequence that automatically paginates through all games.
    ///
    /// This method returns an `AsyncSequence` that fetches games page by page automatically,
    /// yielding individual game objects. It handles pagination internally and supports
    /// task cancellation for efficient resource management.
    ///
    /// - Parameter pageSize: Number of games per page (default: 20, maximum: 40)
    ///
    /// - Returns: An `AsyncThrowingStream` that yields `Game` objects
    ///
    /// ## Usage
    /// ```swift
    /// let client = RAWGClient(apiKey: "your-api-key")
    ///
    /// // Stream all games
    /// for try await game in client.gamesSequence() {
    ///     print(game.name)
    /// }
    ///
    /// // Stop early with break
    /// for try await game in client.gamesSequence() {
    ///     print(game.name)
    ///     if game.metacritic ?? 0 > 95 {
    ///         break // Automatically cancels remaining pages
    ///     }
    /// }
    /// ```
    ///
    /// - Note: The sequence automatically handles pagination and stops when all results are fetched.
    ///   Breaking from the loop will cancel any pending page fetches.
    func gamesSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Game, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchGames(page: page, pageSize: size)
        }
    }

    /// Creates an async sequence that automatically paginates through all game genres.
    ///
    /// Returns an `AsyncSequence` that fetches genres page by page, yielding individual
    /// genre objects. Useful for building genre selection UIs or filtering systems.
    ///
    /// - Parameter pageSize: Number of genres per page (default: 20, maximum: 40)
    /// - Returns: An `AsyncThrowingStream` that yields `Genre` objects
    ///
    /// ## Example
    /// ```swift
    /// let client = RAWGClient(apiKey: "your-api-key")
    /// for try await genre in client.genresSequence() {
    ///     print("\(genre.name): \(genre.gamesCount) games")
    /// }
    /// ```
    func genresSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Genre, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchGenres(page: page, pageSize: size)
        }
    }

    /// Creates an async sequence that automatically paginates through all gaming platforms.
    ///
    /// Returns an `AsyncSequence` that fetches platforms page by page, yielding individual
    /// platform objects including consoles, PC, mobile devices, and more.
    ///
    /// - Parameter pageSize: Number of platforms per page (default: 20, maximum: 40)
    /// - Returns: An `AsyncThrowingStream` that yields `Platform` objects
    ///
    /// ## Example
    /// ```swift
    /// let client = RAWGClient(apiKey: "your-api-key")
    /// for try await platform in client.platformsSequence() {
    ///     print("\(platform.name) - Released: \(platform.yearStart ?? 0)")
    /// }
    /// ```
    func platformsSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Platform, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchPlatforms(page: page, pageSize: size)
        }
    }

    /// Create an async sequence for paginating through developers
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func developersSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Developer, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchDevelopers(page: page, pageSize: size)
        }
    }

    /// Create an async sequence for paginating through publishers
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func publishersSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Publisher, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchPublishers(page: page, pageSize: size)
        }
    }

    /// Creates an async sequence that automatically paginates through all game stores.
    ///
    /// Returns an `AsyncSequence` that fetches digital and physical stores where games
    /// can be purchased, including Steam, PlayStation Store, Xbox Store, and more.
    ///
    /// - Parameter pageSize: Number of stores per page (default: 20, maximum: 40)
    /// - Returns: An `AsyncThrowingStream` that yields `Store` objects
    ///
    /// ## Example
    /// ```swift
    /// let client = RAWGClient(apiKey: "your-api-key")
    /// for try await store in client.storesSequence() {
    ///     print("\(store.name): \(store.domain ?? "N/A")")
    /// }
    /// ```
    func storesSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Store, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchStores(page: page, pageSize: size)
        }
    }

    /// Create an async sequence for paginating through tags
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func tagsSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Tag, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchTags(page: page, pageSize: size)
        }
    }

    /// Create an async sequence for paginating through creators
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func creatorsSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Creator, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchCreators(page: page, pageSize: size)
        }
    }
}

// MARK: - Private Helper

private extension RAWGClient {
    /// Generic paginated sequence with cancellation support
    /// - Parameters:
    ///   - pageSize: Number of items per page
    ///   - fetch: Closure that fetches a page of results
    /// - Returns: An async sequence that yields items from all pages
    func paginatedSequence<T: Sendable>(
        pageSize: Int,
        fetch: @escaping @Sendable (Int, Int) async throws -> RAWGResponse<T>
    ) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                var currentPage = 1
                var hasMore = true

                while hasMore, !Task.isCancelled {
                    do {
                        let response = try await fetch(currentPage, pageSize)

                        for item in response.results {
                            // Check cancellation before yielding each item
                            if Task.isCancelled {
                                continuation.finish()
                                return
                            }
                            continuation.yield(item)
                        }

                        hasMore = response.next != nil
                        currentPage += 1
                    } catch {
                        if !Task.isCancelled {
                            continuation.finish(throwing: error)
                        }
                        return
                    }
                }

                continuation.finish()
            }

            // Handle stream termination (e.g., when consumer stops iterating)
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}
