//
// PaginatedSequence.swift
// RAWGKit
//

import Foundation

/// Extensions for RAWGClient that provide AsyncSequence pagination
public extension RAWGClient {
    /// Create an async sequence for paginating through games
    /// - Parameters:
    ///   - pageSize: Number of items per page (default: 20, max: 40)
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func gamesSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Game, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchGames(page: page, pageSize: size)
        }
    }

    /// Create an async sequence for paginating through genres
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func genresSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Genre, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchGenres(page: page, pageSize: size)
        }
    }

    /// Create an async sequence for paginating through platforms
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages and supports cancellation
    func platformsSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Platform, Error> {
        paginatedSequence(pageSize: pageSize) { page, size in
            try await self.fetchPlatforms(page: page, pageSize: size)
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
