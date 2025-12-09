//
// IntegrationTests.swift
// RAWGKitTests
//
// Integration tests that require a real API key
// Set the RAWG_API_KEY environment variable to run these tests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Integration Tests")
struct IntegrationTests {
    let client: RAWGClient?

    init() {
        // Get API key from environment variable
        if let apiKey = ProcessInfo.processInfo.environment["RAWG_API_KEY"], !apiKey.isEmpty {
            client = RAWGClient(apiKey: apiKey)
        } else {
            client = nil
        }
    }

    @Test("Fetch games returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchGames() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchGames(pageSize: 5)

        #expect(!response.isEmpty)
        #expect(!response.results.isEmpty)
        #expect(response.results.count <= 5)

        if let firstGame = response.results.first {
            #expect(firstGame.id > 0)
            #expect(!firstGame.name.isEmpty)
            #expect(!firstGame.slug.isEmpty)
        }
    }

    @Test(
        "Search games returns relevant results",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func fetchGamesWithSearch() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchGames(
            page: 1,
            pageSize: 5,
            search: "zelda"
        )

        #expect(!response.results.isEmpty)

        let hasZelda = response.results.contains { game in
            game.name.lowercased().contains("zelda")
        }
        #expect(hasZelda == true)
    }

    @Test(
        "Fetch game detail returns valid data",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func fetchGameDetail() async throws {
        guard let client else {
            throw SkipError()
        }

        let game = try await client.fetchGameDetail(id: 3498)

        #expect(game.id == 3498)
        #expect(!game.name.isEmpty)
        #expect(game.description != nil)
        #expect(game.rating > 0)
    }

    @Test(
        "Fetch game screenshots returns images",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func fetchGameScreenshots() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchGameScreenshots(id: 3498, pageSize: 5)

        #expect(!response.results.isEmpty)

        if let firstScreenshot = response.results.first {
            #expect(firstScreenshot.id > 0)
            #expect(!firstScreenshot.image.isEmpty)
        }
    }

    @Test("Fetch genres returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchGenres() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchGenres(pageSize: 10)

        #expect(!response.results.isEmpty)

        if let firstGenre = response.results.first {
            #expect(firstGenre.id > 0)
            #expect(!firstGenre.name.isEmpty)
            #expect(!firstGenre.slug.isEmpty)
        }
    }

    @Test(
        "Fetch genre details returns valid data",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func fetchGenreDetails() async throws {
        guard let client else {
            throw SkipError()
        }

        let genre = try await client.fetchGenreDetails(id: 4)

        #expect(genre.id == 4)
        #expect(!genre.name.isEmpty)
        #expect(genre.gamesCount != nil)
    }

    @Test("Fetch platforms returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchPlatforms() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchPlatforms(pageSize: 10)

        #expect(!response.results.isEmpty)

        if let firstPlatform = response.results.first {
            #expect(firstPlatform.id > 0)
            #expect(!firstPlatform.name.isEmpty)
        }
    }

    @Test(
        "Fetch parent platforms returns results",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func fetchParentPlatforms() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchParentPlatforms(pageSize: 10)

        #expect(!response.results.isEmpty)
    }

    @Test("Fetch developers returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchDevelopers() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchDevelopers(pageSize: 10)

        #expect(!response.results.isEmpty)

        if let firstDev = response.results.first {
            #expect(firstDev.id > 0)
            #expect(!firstDev.name.isEmpty)
        }
    }

    @Test("Fetch publishers returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchPublishers() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchPublishers(pageSize: 10)

        #expect(!response.results.isEmpty)

        if let firstPub = response.results.first {
            #expect(firstPub.id > 0)
            #expect(!firstPub.name.isEmpty)
        }
    }

    @Test("Fetch stores returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchStores() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchStores(pageSize: 10)

        #expect(!response.results.isEmpty)

        if let firstStore = response.results.first {
            #expect(firstStore.id > 0)
            #expect(!firstStore.name.isEmpty)
        }
    }

    @Test("Fetch tags returns results", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func fetchTags() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.fetchTags(pageSize: 10)

        #expect(!response.results.isEmpty)

        if let firstTag = response.results.first {
            #expect(firstTag.id > 0)
            #expect(!firstTag.name.isEmpty)
        }
    }

    @Test("Query builder works with real API", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func queryBuilder() async throws {
        guard let client else {
            throw SkipError()
        }

        let response = try await client.gamesQuery()
            .search("zelda")
            .orderByRating()
            .pageSize(5)
            .execute(with: client)

        #expect(!response.results.isEmpty)
    }

    @Test("Invalid game ID throws error", .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil))
    func invalidGameID() async throws {
        guard let client else {
            throw SkipError()
        }

        await #expect(throws: (any Error).self) {
            try await client.fetchGameDetail(id: 999_999_999)
        }
    }
}

struct SkipError: Error {}
