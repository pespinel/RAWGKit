import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient input validation
@Suite("RAWGClient Input Validation Tests")
struct RAWGClientValidationTests {
    @Test("fetchGameDetail validates resource ID")
    func fetchGameDetailInvalidID() async throws {
        let client = RAWGClient(apiKey: "test")

        do {
            _ = try await client.fetchGameDetail(id: 0)
            Issue.record("Expected validation error for ID 0")
        } catch let error as NetworkError {
            if case NetworkError.apiError = error {
                // Expected validation error
                #expect(Bool(true))
            } else {
                Issue.record("Expected apiError but got \(error)")
            }
        }
    }

    @Test("fetchGameScreenshots validates page number")
    func fetchGameScreenshotsInvalidPage() async throws {
        let client = RAWGClient(apiKey: "test")

        do {
            _ = try await client.fetchGameScreenshots(id: 1, page: 0)
            Issue.record("Expected validation error for page 0")
        } catch let error as NetworkError {
            if case NetworkError.apiError = error {
                #expect(Bool(true))
            }
        }
    }

    @Test("fetchGames validates search query")
    func fetchGamesInvalidSearchQuery() async throws {
        let client = RAWGClient(apiKey: "test")

        // Search with only special characters should fail validation
        do {
            _ = try await client.fetchGames(search: "<script>alert('xss')</script>")
            Issue.record("Expected validation error for XSS attempt")
        } catch let error as NetworkError {
            if case NetworkError.apiError = error {
                #expect(Bool(true))
            }
        }
    }
}
