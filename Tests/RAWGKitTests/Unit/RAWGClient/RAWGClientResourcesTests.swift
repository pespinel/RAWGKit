import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient resource endpoints (genres, platforms, developers, etc.)
@Suite("RAWGClient Resources Tests")
struct RAWGClientResourcesTests {
    @Test("fetchGenres returns genres successfully")
    func fetchGenresSuccess() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse(
            count: 19,
            next: nil,
            previous: nil,
            results: [
                Genre(
                    id: 4,
                    name: "Action",
                    slug: "action",
                    gamesCount: 500,
                    imageBackground: nil
                ),
                Genre(
                    id: 5,
                    name: "RPG",
                    slug: "role-playing-games-rpg",
                    gamesCount: 300,
                    imageBackground: nil
                ),
            ]
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/genres?key=test&page=1&page_size=20"
        )

        let result = try await client.fetchGenres()

        #expect(result.count == 19)
        #expect(result.results.count == 2)
        #expect(result.results[0].name == "Action")
        #expect(result.results[1].name == "RPG")
    }

    @Test("fetchPlatforms returns platforms successfully")
    func fetchPlatformsSuccess() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse(
            count: 50,
            next: nil,
            previous: nil,
            results: [
                Platform(id: 4, name: "PC", slug: "pc"),
                Platform(id: 187, name: "PlayStation 5", slug: "playstation5"),
            ]
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/platforms?key=test&page=1&page_size=20"
        )

        let result = try await client.fetchPlatforms()

        #expect(result.count == 50)
        #expect(result.results.count == 2)
        #expect(result.results[0].name == "PC")
    }

    @Test("fetchDevelopers returns developers successfully")
    func fetchDevelopersSuccess() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        let mockResponse = RAWGResponse(
            count: 100,
            next: nil,
            previous: nil,
            results: [
                Developer(
                    id: 1,
                    name: "CD PROJEKT RED",
                    slug: "cd-projekt-red",
                    gamesCount: 10,
                    imageBackground: nil
                ),
            ]
        )

        try await mock.setMockResponse(
            mockResponse,
            for: "https://api.rawg.io/api/developers?key=test&page=1&page_size=20"
        )

        let result = try await client.fetchDevelopers()

        #expect(result.results.count == 1)
        #expect(result.results[0].name == "CD PROJEKT RED")
    }
}
