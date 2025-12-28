import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient error handling
@Suite("RAWGClient Error Handling Tests")
struct RAWGClientErrorTests {
    @Test("fetchGameDetail throws on 404 not found")
    func fetchGameDetailNotFound() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        await mock.setMockError(
            NetworkError.notFound,
            for: "https://api.rawg.io/api/games/99999?key=test"
        )

        do {
            _ = try await client.fetchGameDetail(id: 99999)
            Issue.record("Expected NetworkError.notFound to be thrown")
        } catch let error as NetworkError {
            #expect(error == NetworkError.notFound)
        } catch {
            Issue.record("Expected NetworkError but got \(type(of: error))")
        }
    }

    @Test("fetchGames throws on unauthorized")
    func fetchGamesUnauthorized() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "invalid", networkManager: mock)

        await mock.setMockError(
            NetworkError.unauthorized,
            for: "https://api.rawg.io/api/games?key=invalid&page=1&page_size=20"
        )

        do {
            _ = try await client.fetchGames()
            Issue.record("Expected NetworkError.unauthorized")
        } catch let error as NetworkError {
            #expect(error == NetworkError.unauthorized)
        }
    }

    @Test("fetchGames throws on rate limit exceeded")
    func fetchGamesRateLimited() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        await mock.setMockError(
            NetworkError.rateLimitExceeded(retryAfter: 60),
            for: "https://api.rawg.io/api/games?key=test&page=1&page_size=20"
        )

        do {
            _ = try await client.fetchGames()
            Issue.record("Expected rate limit error")
        } catch let error as NetworkError {
            if case let NetworkError.rateLimitExceeded(retryAfter) = error {
                #expect(retryAfter == 60)
            } else {
                Issue.record("Expected rateLimitExceeded but got \(error)")
            }
        }
    }

    @Test("fetchGameDetail throws on decoding error")
    func fetchGameDetailDecodingError() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        // Set invalid JSON data that will fail decoding
        let invalidData = Data("invalid json".utf8)
        await mock.setMockResponse(invalidData, for: "https://api.rawg.io/api/games/1?key=test")

        do {
            _ = try await client.fetchGameDetail(id: 1)
            Issue.record("Expected decoding error")
        } catch let error as NetworkError {
            #expect(error == NetworkError.decodingError)
        }
    }
}
