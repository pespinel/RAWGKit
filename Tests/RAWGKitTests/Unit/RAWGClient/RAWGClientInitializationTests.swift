import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient initialization
@Suite("RAWGClient Initialization Tests")
struct RAWGClientInitializationTests {
    @Test("RAWGClient initializes with API key")
    func clientInitialization() throws {
        let apiKey = "test-api-key"
        let client = RAWGClient(apiKey: apiKey)
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("RAWGClient initializes with custom base URL")
    func clientCustomBaseURL() throws {
        let apiKey = "test-key"
        let customURL = "https://custom.api.com"
        let client = RAWGClient(apiKey: apiKey, baseURL: customURL)
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("RAWGClient initializes with cache disabled")
    func clientNoCacheInit() throws {
        let client = RAWGClient(apiKey: "key", cacheEnabled: false)
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("RAWGClient initializes with custom network manager")
    func clientWithMockNetworkManager() async throws {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)
        #expect(type(of: client) == RAWGClient.self)
    }
}
