//
// MockNetworkManagerTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("MockNetworkManager Tests")
struct MockNetworkManagerTests {
    @Test("MockNetworkManager initializes correctly")
    func initialization() async {
        let mock = MockNetworkManager()

        #expect(await mock.fetchCallCount == 0)
        #expect(await mock.cancelCallCount == 0)
        #expect(await mock.clearCacheCallCount == 0)
    }

    @Test("fetch() returns configured mock response")
    func fetchReturnsMockResponse() async throws {
        let mock = MockNetworkManager()

        // Create mock game data
        let mockGame = Game(
            id: 1,
            name: "Test Game",
            slug: "test-game",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.5
        )

        let url = URL(string: "https://api.rawg.io/api/games/1")!
        try await mock.setMockResponse(mockGame, for: url.absoluteString)

        // Fetch should return the mock game
        let result = try await mock.fetch(from: url, as: Game.self, useCache: true)

        #expect(result.id == mockGame.id)
        #expect(result.name == mockGame.name)
        #expect(result.slug == mockGame.slug)
    }

    @Test("fetch() increments call counter")
    func fetchIncrementsCounter() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/1")!

        let mockGame = Game(
            id: 1,
            name: "Test",
            slug: "test",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.0
        )
        try await mock.setMockResponse(mockGame, for: url.absoluteString)

        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)

        let count = await mock.fetchCallCount
        #expect(count == 2)
    }

    @Test("fetch() tracks fetched URLs")
    func fetchTracksURLs() async throws {
        let mock = MockNetworkManager()
        let url1 = URL(string: "https://api.rawg.io/api/games/1")!
        let url2 = URL(string: "https://api.rawg.io/api/games/2")!

        let mockGame = Game(
            id: 1,
            name: "Test",
            slug: "test",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.0
        )

        try await mock.setMockResponse(mockGame, for: url1.absoluteString)
        try await mock.setMockResponse(mockGame, for: url2.absoluteString)

        _ = try await mock.fetch(from: url1, as: Game.self, useCache: true)
        _ = try await mock.fetch(from: url2, as: Game.self, useCache: true)

        let urls = await mock.fetchedURLs
        #expect(urls.count == 2)
        #expect(urls.contains(url1))
        #expect(urls.contains(url2))
    }

    @Test("fetch() throws configured error")
    func fetchThrowsConfiguredError() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/1")!

        await mock.setMockError(NetworkError.unauthorized, for: url.absoluteString)

        do {
            _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
            Issue.record("Expected NetworkError.unauthorized to be thrown")
        } catch let error as NetworkError {
            #expect(error == NetworkError.unauthorized)
        } catch {
            Issue.record("Expected NetworkError but got \(type(of: error))")
        }
    }

    @Test("fetch() throws notFound for unconfigured URL")
    func fetchThrowsNotFoundForUnconfiguredURL() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/999")!

        do {
            _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
            Issue.record("Expected NetworkError.notFound to be thrown")
        } catch let error as NetworkError {
            #expect(error == NetworkError.notFound)
        } catch {
            Issue.record("Expected NetworkError but got \(type(of: error))")
        }
    }

    @Test("cancelAllRequests() increments counter")
    func cancelIncrementsCounter() async {
        let mock = MockNetworkManager()

        await mock.cancelAllRequests()
        await mock.cancelAllRequests()

        let count = await mock.cancelCallCount
        #expect(count == 2)
    }

    @Test("clearCache() increments counter")
    func clearCacheIncrementsCounter() async {
        let mock = MockNetworkManager()

        await mock.clearCache()
        await mock.clearCache()

        let count = await mock.clearCacheCallCount
        #expect(count == 2)
    }

    @Test("cacheStats() returns configured stats")
    func cacheStatsReturnsConfiguredStats() async {
        let mock = MockNetworkManager()

        await mock.setMockCacheStats(
            CacheManager.CacheStats(
                totalEntries: 10,
                validEntries: 8,
                expiredEntries: 2
            )
        )

        let stats = await mock.cacheStats()

        #expect(stats.totalEntries == 10)
        #expect(stats.validEntries == 8)
        #expect(stats.expiredEntries == 2)
    }

    @Test("buildURL() constructs URL correctly")
    func buildURLConstructsCorrectly() async throws {
        let mock = MockNetworkManager()

        let url = try await mock.buildURL(
            baseURL: "https://api.rawg.io/api",
            path: "/games",
            queryItems: ["key": "test", "page": "1"]
        )

        #expect(url.absoluteString.contains("api.rawg.io/api/games"))
        #expect(url.absoluteString.contains("key=test"))
        #expect(url.absoluteString.contains("page=1"))
    }

    @Test("reset() clears all counters and data")
    func resetClearsAllData() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/1")!

        let mockGame = Game(
            id: 1,
            name: "Test",
            slug: "test",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.0
        )
        try await mock.setMockResponse(mockGame, for: url.absoluteString)

        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
        await mock.cancelAllRequests()
        await mock.clearCache()

        await mock.reset()

        #expect(await mock.fetchCallCount == 0)
        #expect(await mock.cancelCallCount == 0)
        #expect(await mock.clearCacheCallCount == 0)
        #expect(await mock.fetchedURLs.isEmpty)
    }

    @Test("wasFetched() returns true for fetched URLs")
    func wasFetchedReturnsTrueForFetchedURLs() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/1")!

        let mockGame = Game(
            id: 1,
            name: "Test",
            slug: "test",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.0
        )
        try await mock.setMockResponse(mockGame, for: url.absoluteString)

        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)

        let wasFetched = await mock.wasFetched(url)
        #expect(wasFetched == true)
    }

    @Test("fetchCount() returns correct count for URL")
    func fetchCountReturnsCorrectCount() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/1")!

        let mockGame = Game(
            id: 1,
            name: "Test",
            slug: "test",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.0
        )
        try await mock.setMockResponse(mockGame, for: url.absoluteString)

        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
        _ = try await mock.fetch(from: url, as: Game.self, useCache: true)

        let count = await mock.fetchCount(for: url)
        #expect(count == 3)
    }

    @Test("clearMocks() removes all mock responses and errors")
    func clearMocksRemovesAll() async throws {
        let mock = MockNetworkManager()
        let url = URL(string: "https://api.rawg.io/api/games/1")!

        let mockGame = Game(
            id: 1,
            name: "Test",
            slug: "test",
            backgroundImage: nil,
            released: "2020-01-01",
            rating: 4.0
        )
        try await mock.setMockResponse(mockGame, for: url.absoluteString)
        await mock.setMockError(NetworkError.unauthorized, for: url.absoluteString)

        await mock.clearMocks()

        // Should throw notFound since no mocks configured
        do {
            _ = try await mock.fetch(from: url, as: Game.self, useCache: true)
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected
        }
    }

    @Test("MockNetworkManager can be used with RAWGClient")
    func usageWithRAWGClient() async throws {
        let mock = MockNetworkManager()

        // Configure mock response
        let mockGame = GameDetail(
            id: 1,
            name: "Test Game",
            slug: "test-game",
            nameOriginal: nil,
            description: "A test game",
            descriptionRaw: nil,
            metacritic: 85,
            released: "2020-01-01",
            tba: false,
            updated: nil,
            backgroundImage: nil,
            backgroundImageAdditional: nil,
            website: nil,
            rating: 4.5,
            ratingTop: nil,
            ratingsCount: nil,
            ratings: nil,
            playtime: nil,
            platforms: [],
            genres: [],
            tags: nil,
            publishers: [],
            developers: [],
            esrbRating: nil
        )

        try await mock.setMockResponse(
            mockGame,
            for: "https://api.rawg.io/api/games/1?key=test"
        )

        // Create RAWGClient with mock
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        // This would normally make a network request, but uses our mock instead
        let game = try await client.fetchGameDetail(id: 1)

        #expect(game.id == 1)
        #expect(game.name == "Test Game")
        #expect(await mock.fetchCallCount == 1)
    }
}

// MARK: - Helper Extensions

extension MockNetworkManager {
    func setMockCacheStats(_ stats: CacheManager.CacheStats) {
        mockCacheStats = stats
    }
}
