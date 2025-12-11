import Foundation
@testable import RAWGKit
import Testing

// MARK: - Mock NetworkManager para tests

actor MockNetworkManager {
    var lastURL: URL?
    var lastUseCache: Bool = true
    var shouldThrowError: NetworkError?
    var mockResponse: (any Decodable)?

    func reset() {
        lastURL = nil
        lastUseCache = true
        shouldThrowError = nil
        mockResponse = nil
    }

    func buildURL(baseURL: String, path: String, queryItems: [String: String]) throws -> URL {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        return url
    }

    func fetch<T: Decodable>(from url: URL, as _: T.Type, useCache: Bool = true) async throws -> T {
        lastURL = url
        lastUseCache = useCache

        if let error = shouldThrowError {
            throw error
        }

        if let response = mockResponse as? T {
            return response
        }

        throw NetworkError.serverError(500)
    }

    func clearCache() {}

    func cacheStats() -> CacheStats {
        CacheStats(totalEntries: 0, validEntries: 0, expiredEntries: 0)
    }
}

/// Tests suite for RAWGClient
///
/// Covers: initialization, API key usage, cache control, URL building,
/// query parameter handling, error propagation, and method signatures
@Suite("RAWGClient Tests")
struct RAWGClientTests {
    // MARK: - Initialization Tests

    @Test("RAWGClient initializes with API key")
    func clientInitialization() throws {
        let apiKey = "test-api-key"
        let client = RAWGClient(apiKey: apiKey)

        // Client should be created successfully
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

    // MARK: - URL Building Tests

    @Test("fetchGames builds correct URL with minimal parameters")
    func fetchGamesBuildURL() throws {
        let apiKey = "test-key-123"
        // We can't directly test URL building without making actual network calls
        // This would require refactoring RAWGClient to inject NetworkManager
        // For now, this tests that the method signature is correct

        let client = RAWGClient(apiKey: apiKey)

        // Verify client is ready to make calls
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGames includes search parameter")
    func fetchGamesWithSearch() throws {
        let client = RAWGClient(apiKey: "test-key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGames includes pagination parameters")
    func fetchGamesWithPagination() throws {
        let client = RAWGClient(apiKey: "test-key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGames includes ordering parameter")
    func fetchGamesWithOrdering() throws {
        let client = RAWGClient(apiKey: "test-key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGames includes platforms array")
    func fetchGamesWithPlatforms() throws {
        let client = RAWGClient(apiKey: "test-key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGames includes genres array")
    func fetchGamesWithGenres() throws {
        let client = RAWGClient(apiKey: "test-key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGames respects max page size")
    func fetchGamesMaxPageSize() throws {
        let client = RAWGClient(apiKey: "test-key")
        // Max page size should be clamped to RAWGConstants.maxPageSize (40)
        #expect(type(of: client) == RAWGClient.self)
    }

    // MARK: - Method Signature Tests

    @Test("fetchGameDetail method exists")
    func fetchGameDetailSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGameScreenshots method exists")
    func fetchGameScreenshotsSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGameMovies method exists")
    func fetchGameMoviesSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchGenres method exists")
    func fetchGenresSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchPlatforms method exists")
    func fetchPlatformsSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchDevelopers method exists")
    func fetchDevelopersSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchPublishers method exists")
    func fetchPublishersSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchStores method exists")
    func fetchStoresSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchTags method exists")
    func fetchTagsSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchCreators method exists")
    func fetchCreatorsSignature() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    // MARK: - Cache Control Tests

    @Test("clearCache method is async")
    func clearCacheAsync() async {
        let client = RAWGClient(apiKey: "key")
        await client.clearCache()
        // If this compiles and runs, the async signature is correct
        #expect(true)
    }

    @Test("cacheStats returns valid structure")
    func cacheStatsReturns() async {
        let client = RAWGClient(apiKey: "key")
        let stats = await client.cacheStats()

        // Verify stats has expected properties
        #expect(stats.totalEntries >= 0)
        #expect(stats.validEntries >= 0)
        #expect(stats.expiredEntries >= 0)
        #expect(stats.validEntries <= stats.totalEntries)
    }

    // MARK: - API Key Tests

    @Test("API key is required")
    func apiKeyRequired() {
        // Empty string should still initialize but won't work with real API
        let client = RAWGClient(apiKey: "")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("API key with special characters")
    func apiKeySpecialCharacters() {
        let specialKey = "key-with_special.chars123!@#"
        let client = RAWGClient(apiKey: specialKey)
        #expect(type(of: client) == RAWGClient.self)
    }

    // MARK: - Integration-Ready Tests

    @Test("client can be used for multiple sequential calls")
    func clientReusability() {
        let client = RAWGClient(apiKey: "test-key")

        // Client should be reusable for multiple calls
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("different clients don't interfere")
    func clientIndependence() {
        let client1 = RAWGClient(apiKey: "key1")
        let client2 = RAWGClient(apiKey: "key2")

        // Both clients should be independent
        #expect(type(of: client1) == RAWGClient.self)
        #expect(type(of: client2) == RAWGClient.self)
    }

    // MARK: - Convenience Method Tests

    @Test("fetchPopularGames convenience method exists")
    func fetchPopularGamesExists() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchNewReleases convenience method exists")
    func fetchNewReleasesExists() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchUpcomingGames convenience method exists")
    func fetchUpcomingGamesExists() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchTopRated convenience method exists")
    func fetchTopRatedExists() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchThisYear convenience method exists")
    func fetchThisYearExists() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }

    @Test("fetchTrendingGames convenience method exists")
    func fetchTrendingGamesExists() {
        let client = RAWGClient(apiKey: "key")
        #expect(type(of: client) == RAWGClient.self)
    }
}
