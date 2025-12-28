import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient games endpoint
@Suite("RAWGClient Games Endpoint Tests")
struct RAWGClientGamesTests {
    @Test("fetchGames returns games successfully")
    func fetchGamesSuccess() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test-key", networkManager: mock)

        let mockResponse = RAWGResponse(
            count: 100,
            next: "https://api.rawg.io/api/games?page=2",
            previous: nil,
            results: [
                Game(
                    id: 1,
                    name: "The Witcher 3",
                    slug: "the-witcher-3",
                    backgroundImage: "https://example.com/image.jpg",
                    released: "2015-05-19",
                    rating: 4.5
                ),
                Game(
                    id: 2,
                    name: "Cyberpunk 2077",
                    slug: "cyberpunk-2077",
                    backgroundImage: nil,
                    released: "2020-12-10",
                    rating: 4.0
                ),
            ]
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/games?key=test-key&page=1&page_size=20"
        )

        let result = try await client.fetchGames()

        #expect(result.count == 100)
        #expect(result.results.count == 2)
        #expect(result.results[0].name == "The Witcher 3")
        #expect(result.results[1].name == "Cyberpunk 2077")
        #expect(await mock.fetchCallCount == 1)
    }

    @Test("fetchGames with search parameter")
    func fetchGamesWithSearch() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse(
            count: 10,
            next: nil,
            previous: nil,
            results: [
                Game(
                    id: 1,
                    name: "Witcher",
                    slug: "witcher",
                    backgroundImage: nil,
                    released: "2015-01-01",
                    rating: 4.5
                ),
            ]
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/games?key=test&page=1&page_size=20&search=Witcher"
        )

        let result = try await client.fetchGames(search: "Witcher")

        #expect(result.results.count == 1)
        #expect(result.results[0].name == "Witcher")
    }

    @Test("fetchGames with pagination parameters")
    func fetchGamesWithPagination() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse<Game>(
            count: 100,
            next: "https://api.rawg.io/api/games?page=3",
            previous: "https://api.rawg.io/api/games?page=1",
            results: []
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/games?key=test&page=2&page_size=10"
        )

        let result = try await client.fetchGames(page: 2, pageSize: 10)

        #expect(result.count == 100)
        #expect(result.next != nil)
        #expect(result.previous != nil)
    }

    @Test("fetchGames with platforms and genres")
    func fetchGamesWithFilters() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse<Game>(count: 50, next: nil, previous: nil, results: [])

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/games?key=test&page=1&page_size=20&platforms=4,187&genres=4,5"
        )

        let result = try await client.fetchGames(platforms: [4, 187], genres: [4, 5])

        #expect(result.count == 50)
        #expect(await mock.fetchCallCount == 1)
    }

    @Test("fetchGames respects max page size")
    func fetchGamesMaxPageSize() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse<Game>(count: 100, next: nil, previous: nil, results: [])

        // Should clamp to 40 (RAWGConstants.maxPageSize)
        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/games?key=test&page=1&page_size=40"
        )

        _ = try await client.fetchGames(pageSize: 100)

        let urls = await mock.fetchedURLs
        #expect(urls[0].absoluteString.contains("page_size=40"))
    }

    @Test("fetchGameDetail returns game details")
    func fetchGameDetailSuccess() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockGame = GameDetail(
            id: 3328,
            name: "The Witcher 3: Wild Hunt",
            slug: "the-witcher-3-wild-hunt",
            nameOriginal: "The Witcher 3: Wild Hunt",
            description: "<p>Epic RPG game</p>",
            descriptionRaw: "Epic RPG game",
            metacritic: 92,
            released: "2015-05-19",
            tba: false,
            updated: "2024-01-01T00:00:00",
            backgroundImage: "https://example.com/bg.jpg",
            backgroundImageAdditional: nil,
            website: "https://thewitcher.com",
            rating: 4.65,
            ratingTop: 5,
            ratingsCount: 5000,
            ratings: nil,
            playtime: 51,
            platforms: [],
            genres: [],
            tags: nil,
            publishers: [],
            developers: [],
            esrbRating: nil
        )

        try await mock.setMockResponse(mockGame, for: "https://api.rawg.io/api/games/3328?key=test")

        let result = try await client.fetchGameDetail(id: 3328)

        #expect(result.id == 3328)
        #expect(result.name == "The Witcher 3: Wild Hunt")
        #expect(result.metacritic == 92)
        #expect(result.rating == 4.65)
    }

    @Test("fetchGameScreenshots returns screenshots")
    func fetchGameScreenshotsSuccess() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = ScreenshotsResponse(
            count: 20,
            next: nil,
            previous: nil,
            results: [
                Screenshot(
                    id: 1,
                    image: "https://example.com/screenshot1.jpg",
                    width: 1920,
                    height: 1080,
                    isDeleted: false
                ),
                Screenshot(
                    id: 2,
                    image: "https://example.com/screenshot2.jpg",
                    width: 1920,
                    height: 1080,
                    isDeleted: false
                ),
            ]
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/games/3328/screenshots?key=test&page=1&page_size=20"
        )

        let result = try await client.fetchGameScreenshots(id: 3328)

        #expect(result.count == 20)
        #expect(result.results.count == 2)
        #expect(result.results[0].width == 1920)
    }
}
