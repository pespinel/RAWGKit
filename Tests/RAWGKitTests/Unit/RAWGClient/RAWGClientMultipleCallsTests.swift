import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient multiple calls and URL building
@Suite("RAWGClient Multiple Calls Tests")
struct RAWGClientMultipleCallsTests {
    @Test("client can handle multiple sequential calls")
    func clientHandlesMultipleCalls() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let gamesResponse = RAWGResponse<Game>(count: 0, next: nil, previous: nil, results: [])
        let genresResponse = RAWGResponse<Genre>(count: 0, next: nil, previous: nil, results: [])

        try await mock.setMockResponse(
            gamesResponse,
            for: "https://api.rawg.io/api/games?key=test&page=1&page_size=20"
        )
        try await mock.setMockResponse(
            genresResponse,
            for: "https://api.rawg.io/api/genres?key=test&page=1&page_size=20"
        )

        _ = try await client.fetchGames()
        _ = try await client.fetchGenres()

        let count = await mock.fetchCallCount
        #expect(count == 2)
    }

    @Test("different clients with different mocks are independent")
    func clientsAreIndependent() async throws {
        let mock1 = MockNetworkManager()
        let mock2 = MockNetworkManager()

        let client1 = RAWGClient(apiKey: "test1", networkManager: mock1)
        let client2 = RAWGClient(apiKey: "test2", networkManager: mock2)

        let response = RAWGResponse<Game>(count: 0, next: nil, previous: nil, results: [])

        try await mock1.setMockResponse(
            response,
            for: "https://api.rawg.io/api/games?key=test1&page=1&page_size=20"
        )
        try await mock2.setMockResponse(
            response,
            for: "https://api.rawg.io/api/games?key=test2&page=1&page_size=20"
        )

        _ = try await client1.fetchGames()
        _ = try await client2.fetchGames()

        let count1 = await mock1.fetchCallCount
        let count2 = await mock2.fetchCallCount

        #expect(count1 == 1)
        #expect(count2 == 1)
    }

    @Test("fetchGames builds correct URL with all parameters")
    func fetchGamesBuildsCompleteURL() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let response = RAWGResponse<Game>(count: 0, next: nil, previous: nil, results: [])

        try await mock.setMockResponse(
            response,
            for: "https://api.rawg.io/api/games?key=test&page=2&page_size=10&search=Witcher&platforms=4&genres=5&ordering=-rating"
        )

        _ = try await client.fetchGames(
            page: 2,
            pageSize: 10,
            search: "Witcher",
            ordering: "-rating",
            platforms: [4],
            genres: [5]
        )

        let urls = await mock.fetchedURLs
        let urlString = urls[0].absoluteString

        #expect(urlString.contains("page=2"))
        #expect(urlString.contains("page_size=10"))
        #expect(urlString.contains("search=Witcher"))
        #expect(urlString.contains("platforms=4"))
        #expect(urlString.contains("genres=5"))
        #expect(urlString.contains("ordering=-rating"))
    }
}
