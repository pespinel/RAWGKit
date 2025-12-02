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
    /// - Returns: An async sequence that automatically fetches pages
    func gamesSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Game, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var currentPage = 1
                var hasMore = true

                while hasMore {
                    do {
                        let response = try await self.fetchGames(
                            page: currentPage,
                            pageSize: pageSize
                        )

                        for game in response.results {
                            continuation.yield(game)
                        }

                        hasMore = response.next != nil
                        currentPage += 1
                    } catch {
                        continuation.finish(throwing: error)
                        return
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Create an async sequence for paginating through genres
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages
    func genresSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Genre, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var currentPage = 1
                var hasMore = true

                while hasMore {
                    do {
                        let response = try await self.fetchGenres(
                            page: currentPage,
                            pageSize: pageSize
                        )

                        for genre in response.results {
                            continuation.yield(genre)
                        }

                        hasMore = response.next != nil
                        currentPage += 1
                    } catch {
                        continuation.finish(throwing: error)
                        return
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Create an async sequence for paginating through platforms
    /// - Parameter pageSize: Number of items per page
    /// - Returns: An async sequence that automatically fetches pages
    func platformsSequence(
        pageSize: Int = 20
    ) -> AsyncThrowingStream<Platform, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var currentPage = 1
                var hasMore = true

                while hasMore {
                    do {
                        let response = try await self.fetchPlatforms(
                            page: currentPage,
                            pageSize: pageSize
                        )

                        for platform in response.results {
                            continuation.yield(platform)
                        }

                        hasMore = response.next != nil
                        currentPage += 1
                    } catch {
                        continuation.finish(throwing: error)
                        return
                    }
                }

                continuation.finish()
            }
        }
    }
}
