//
// MockNetworkManager.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit

/// Mock implementation of NetworkManaging protocol for testing purposes.
///
/// `MockNetworkManager` provides a configurable mock for testing components that depend on
/// network operations without making actual HTTP requests. It supports:
///
/// - Pre-configured responses for specific URLs
/// - Error injection for testing error handling
/// - Call verification to ensure methods are invoked correctly
/// - Customizable delays to simulate network latency
///
/// ## Usage
///
/// ```swift
/// // Setup mock responses
/// let mockManager = MockNetworkManager()
/// let gameData = try! JSONEncoder().encode(mockGame)
/// mockManager.mockResponses["https://api.rawg.io/api/games/1"] = gameData
///
/// // Inject into RAWGClient
/// let client = RAWGClient(apiKey: "test", networkManager: mockManager)
///
/// // Verify calls
/// XCTAssertEqual(mockManager.fetchCallCount, 1)
/// ```
public actor MockNetworkManager: NetworkManaging {
    // MARK: - Mock Configuration

    /// Dictionary mapping URLs to mock response data
    public var mockResponses: [String: Data] = [:]

    /// Dictionary mapping URLs to errors to throw
    public var mockErrors: [String: any Error] = [:]

    /// Simulated network delay in seconds (default: 0)
    public var simulatedDelay: TimeInterval = 0

    /// Whether all cache operations should succeed (default: true)
    public var cacheOperationsSucceed: Bool = true

    // MARK: - Call Tracking

    /// Number of times fetch() was called
    public private(set) var fetchCallCount: Int = 0

    /// URLs passed to fetch() calls
    public private(set) var fetchedURLs: [URL] = []

    /// Number of times cancelAllRequests() was called
    public private(set) var cancelCallCount: Int = 0

    /// Number of times clearCache() was called
    public private(set) var clearCacheCallCount: Int = 0

    /// Number of times cacheStats() was called
    public private(set) var cacheStatsCallCount: Int = 0

    /// Number of times buildURL() was called
    public private(set) var buildURLCallCount: Int = 0

    // MARK: - Mock Cache Stats

    /// Mock cache statistics to return from cacheStats()
    public var mockCacheStats = CacheManager.CacheStats(
        totalEntries: 0,
        validEntries: 0,
        expiredEntries: 0
    )

    // MARK: - Initialization

    public init() {}

    // MARK: - NetworkManaging Protocol Implementation

    public func fetch<T: Decodable>(from url: URL, as _: T.Type, useCache _: Bool) async throws -> T {
        fetchCallCount += 1
        fetchedURLs.append(url)

        // Simulate network delay if configured
        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }

        // Try exact match first
        let urlString = url.absoluteString

        // Check for configured error
        if let error = mockErrors[urlString] {
            throw error
        }

        // Check for configured response
        if let data = mockResponses[urlString] {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        }

        // Try flexible matching by comparing URL components (path + sorted query items)
        if let matchedData = try? findMatchingResponse(for: url) {
            do {
                return try JSONDecoder().decode(T.self, from: matchedData)
            } catch {
                throw NetworkError.decodingError
            }
        }

        // Try flexible error matching
        if let matchedError = try? findMatchingError(for: url) {
            throw matchedError
        }

        throw NetworkError.notFound
    }

    /// Finds a matching response by comparing URL components instead of exact string match
    private func findMatchingResponse(for url: URL) throws -> Data? {
        guard let targetComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        for (mockURLString, data) in mockResponses {
            guard let mockURL = URL(string: mockURLString),
                  let mockComponents = URLComponents(url: mockURL, resolvingAgainstBaseURL: false) else {
                continue
            }

            // Compare scheme, host, and path
            guard targetComponents.scheme == mockComponents.scheme,
                  targetComponents.host == mockComponents.host,
                  targetComponents.path == mockComponents.path else {
                continue
            }

            // Compare query items (order-independent)
            if queryItemsMatch(targetComponents.queryItems, mockComponents.queryItems) {
                return data
            }
        }

        return nil
    }

    /// Finds a matching error by comparing URL components instead of exact string match
    private func findMatchingError(for url: URL) throws -> (any Error)? {
        guard let targetComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        for (mockURLString, error) in mockErrors {
            guard let mockURL = URL(string: mockURLString),
                  let mockComponents = URLComponents(url: mockURL, resolvingAgainstBaseURL: false) else {
                continue
            }

            // Compare scheme, host, and path
            guard targetComponents.scheme == mockComponents.scheme,
                  targetComponents.host == mockComponents.host,
                  targetComponents.path == mockComponents.path else {
                continue
            }

            // Compare query items (order-independent)
            if queryItemsMatch(targetComponents.queryItems, mockComponents.queryItems) {
                return error
            }
        }

        return nil
    }

    /// Compares two sets of query items in an order-independent way
    private func queryItemsMatch(_ items1: [URLQueryItem]?, _ items2: [URLQueryItem]?) -> Bool {
        struct QueryItemPair: Hashable {
            let name: String
            let value: String
        }

        let set1 = Set((items1 ?? []).map { QueryItemPair(name: $0.name, value: $0.value ?? "") })
        let set2 = Set((items2 ?? []).map { QueryItemPair(name: $0.name, value: $0.value ?? "") })
        return set1 == set2
    }

    public func cancelAllRequests() {
        cancelCallCount += 1
    }

    public func clearCache() async {
        clearCacheCallCount += 1
    }

    public func cacheStats() async -> CacheManager.CacheStats {
        cacheStatsCallCount += 1
        return mockCacheStats
    }

    nonisolated public func buildURL(
        baseURL: String,
        path: String,
        queryItems: [String: String]
    ) throws -> URL {
        // Use a simple task to increment the counter in an actor-isolated context
        Task {
            await incrementBuildURLCallCount()
        }

        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        return url
    }

    private func incrementBuildURLCallCount() {
        buildURLCallCount += 1
    }

    // MARK: - Test Helpers

    /// Resets all call counters and tracked data
    public func reset() {
        fetchCallCount = 0
        fetchedURLs = []
        cancelCallCount = 0
        clearCacheCallCount = 0
        cacheStatsCallCount = 0
        buildURLCallCount = 0
        mockResponses = [:]
        mockErrors = [:]
        simulatedDelay = 0
    }

    /// Configures a mock response for a URL
    /// - Parameters:
    ///   - data: The data to return
    ///   - url: The URL to match
    public func setMockResponse(_ data: Data, for url: String) {
        mockResponses[url] = data
    }

    /// Configures a mock response by encoding an object
    /// - Parameters:
    ///   - object: The object to encode and return
    ///   - url: The URL to match
    public func setMockResponse(_ object: some Encodable, for url: String) throws {
        let data = try JSONEncoder().encode(object)
        mockResponses[url] = data
    }

    /// Configures an error to throw for a URL
    /// - Parameters:
    ///   - error: The error to throw
    ///   - url: The URL to match
    public func setMockError(_ error: any Error, for url: String) {
        mockErrors[url] = error
    }

    /// Removes all mock responses and errors
    public func clearMocks() {
        mockResponses = [:]
        mockErrors = [:]
    }

    /// Returns whether a URL was fetched
    /// - Parameter url: The URL to check
    /// - Returns: True if the URL was fetched
    public func wasFetched(_ url: URL) -> Bool {
        fetchedURLs.contains(url)
    }

    /// Returns the number of times a URL was fetched
    /// - Parameter url: The URL to count
    /// - Returns: The fetch count
    public func fetchCount(for url: URL) -> Int {
        fetchedURLs.filter { $0 == url }.count
    }
}
