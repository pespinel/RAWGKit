//
// NetworkManaging.swift
// RAWGKit
//

import Foundation

/// Protocol defining the contract for network management operations.
///
/// `NetworkManaging` provides an abstraction layer over networking operations,
/// enabling dependency injection and easier testing through mock implementations.
/// All conforming types must be actors to ensure thread-safe network operations.
///
/// ## Protocol Requirements
///
/// Conforming types must implement:
/// - Data fetching with caching support
/// - Request cancellation
/// - Cache management (clear, statistics)
/// - URL building utilities
///
/// ## Usage
///
/// This protocol is primarily used for dependency injection in `RAWGClient`:
///
/// ```swift
/// // Production usage with real NetworkManager
/// let client = RAWGClient(apiKey: "key")
///
/// // Testing with mock implementation
/// let mockManager = MockNetworkManager()
/// let client = RAWGClient(apiKey: "key", networkManager: mockManager)
/// ```
///
/// - Note: All conforming types must be actors for thread-safe concurrent access.
public protocol NetworkManaging: Actor {
    /// Fetches and decodes data from a URL with optional caching.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch data from
    ///   - type: The type to decode the response into
    ///   - useCache: Whether to use cached data if available
    /// - Returns: The decoded object of type T
    /// - Throws: `NetworkError` if the request fails or decoding fails
    func fetch<T: Decodable>(from url: URL, as type: T.Type, useCache: Bool) async throws -> T

    /// Cancels all active network requests.
    ///
    /// This method immediately cancels all in-flight requests and clears
    /// the active tasks dictionary. Useful for cleanup when leaving a screen
    /// or when the user cancels an operation.
    func cancelAllRequests()

    /// Clears all cached data.
    ///
    /// Removes all entries from the cache, freeing up memory.
    /// Subsequent requests will fetch fresh data from the network.
    func clearCache() async

    /// Returns statistics about the current cache state.
    ///
    /// - Returns: Cache statistics including total, valid, and expired entries
    func cacheStats() async -> CacheManager.CacheStats

    /// Builds a URL from components with query parameters.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL string (e.g., "https://api.rawg.io/api")
    ///   - path: The path to append (e.g., "/games")
    ///   - queryItems: Dictionary of query parameters to include
    /// - Returns: The constructed URL
    /// - Throws: `NetworkError.invalidURL` if the URL cannot be constructed
    nonisolated func buildURL(
        baseURL: String,
        path: String,
        queryItems: [String: String]
    ) throws -> URL
}

// MARK: - Default Implementations

public extension NetworkManaging {
    /// Fetches and decodes data from a URL with caching enabled by default.
    ///
    /// This is a convenience method that calls `fetch(from:as:useCache:)` with `useCache: true`.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch data from
    ///   - type: The type to decode the response into
    /// - Returns: The decoded object of type T
    /// - Throws: `NetworkError` if the request fails or decoding fails
    func fetch<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
        try await fetch(from: url, as: type, useCache: true)
    }
}
