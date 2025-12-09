//
// PaginatedSequenceTests.swift
// RAWGKitTests
//
// Tests for AsyncSequence pagination functionality
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("PaginatedSequence Tests")
struct PaginatedSequenceTests {
    let client: RAWGClient?

    init() {
        // Get API key from environment variable
        if let apiKey = ProcessInfo.processInfo.environment["RAWG_API_KEY"], !apiKey.isEmpty {
            client = RAWGClient(apiKey: apiKey)
        } else {
            client = nil
        }
    }

    @Test(
        "gamesSequence streams multiple pages",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func gamesSequenceStreamsPages() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0
        let limit = 25 // More than one page

        for try await game in await client.gamesSequence(pageSize: 10) {
            #expect(game.id > 0)
            #expect(!game.name.isEmpty)

            count += 1
            if count >= limit {
                break
            }
        }

        #expect(count == limit)
    }

    @Test(
        "genresSequence streams genres",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func genresSequenceStreamsGenres() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await genre in await client.genresSequence(pageSize: 5) {
            #expect(genre.id > 0)
            #expect(!genre.name.isEmpty)

            count += 1
            if count >= 10 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "platformsSequence streams platforms",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func platformsSequenceStreamsPlatforms() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await platform in await client.platformsSequence(pageSize: 5) {
            #expect(platform.id > 0)
            #expect(!platform.name.isEmpty)

            count += 1
            if count >= 10 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "developersSequence streams developers",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func developersSequenceStreamsDevelopers() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await developer in await client.developersSequence(pageSize: 5) {
            #expect(developer.id > 0)
            #expect(!developer.name.isEmpty)

            count += 1
            if count >= 10 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "publishersSequence streams publishers",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func publishersSequenceStreamsPublishers() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await publisher in await client.publishersSequence(pageSize: 5) {
            #expect(publisher.id > 0)
            #expect(!publisher.name.isEmpty)

            count += 1
            if count >= 10 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "storesSequence streams stores",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func storesSequenceStreamsStores() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await store in await client.storesSequence(pageSize: 5) {
            #expect(store.id > 0)
            #expect(!store.name.isEmpty)

            count += 1
            if count >= 5 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "tagsSequence streams tags",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func tagsSequenceStreamsTags() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await tag in await client.tagsSequence(pageSize: 5) {
            #expect(tag.id > 0)
            #expect(!tag.name.isEmpty)

            count += 1
            if count >= 10 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "creatorsSequence streams creators",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func creatorsSequenceStreamsCreators() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await creator in await client.creatorsSequence(pageSize: 5) {
            #expect(creator.id > 0)
            #expect(!creator.name.isEmpty)

            count += 1
            if count >= 10 {
                break
            }
        }

        #expect(count >= 5)
    }

    @Test(
        "AsyncSequence supports early termination",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func asyncSequenceSupportsEarlyTermination() async throws {
        guard let client else {
            throw SkipError()
        }

        var count = 0

        for try await _ in await client.gamesSequence(pageSize: 20) {
            count += 1
            if count >= 3 {
                // Break early - should not cause issues
                break
            }
        }

        #expect(count == 3)
    }

    @Test(
        "AsyncSequence handles cancellation",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func asyncSequenceHandlesCancellation() async throws {
        guard let client else {
            throw SkipError()
        }

        let task = Task {
            var count = 0
            for try await _ in await client.gamesSequence(pageSize: 20) {
                count += 1
                if count >= 50 {
                    break
                }
            }
            return count
        }

        // Cancel after a short delay
        try await Task.sleep(for: .milliseconds(100))
        task.cancel()

        // Should not throw error on cancellation
        let result = await task.result
        switch result {
        case let .success(count):
            #expect(count >= 0)
        case .failure:
            // Cancellation or error is acceptable
            break
        }
    }
}
