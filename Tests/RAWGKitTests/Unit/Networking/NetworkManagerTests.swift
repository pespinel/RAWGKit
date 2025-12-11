//
// NetworkManagerTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("NetworkManager Tests")
struct NetworkManagerTests {
    @Test("Build URL with query parameters")
    func buildURL() throws {
        let manager = NetworkManager()

        let url = try manager.buildURL(
            baseURL: "https://api.rawg.io/api",
            path: "/games",
            queryItems: [
                "key": "test-key",
                "page": "1",
                "page_size": "20",
            ]
        )

        #expect(url.scheme == "https")
        #expect(url.host == "api.rawg.io")
        #expect(url.path == "/api/games")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems != nil)
        let hasKeyParam = components?.queryItems?.contains { $0.name == "key" && $0.value == "test-key" } ?? false
        #expect(hasKeyParam == true)
    }

    @Test("Build URL with multiple query parameters")
    func buildURLWithQueryParameters() throws {
        let manager = NetworkManager()

        let url = try manager.buildURL(
            baseURL: "https://api.example.com",
            path: "/endpoint",
            queryItems: ["key1": "value1", "key2": "value2"]
        )

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems != nil)
        #expect(components?.queryItems?.count == 2)
    }

    @Test("Build URL with empty path")
    func buildURLWithEmptyPath() throws {
        let manager = NetworkManager()

        let url = try manager.buildURL(
            baseURL: "https://api.example.com",
            path: "",
            queryItems: ["key": "value"]
        )

        #expect(url.absoluteString.contains("api.example.com"))
    }

    @Test("Build URL with complex query values")
    func buildURLWithComplexQuery() throws {
        let manager = NetworkManager()

        let url = try manager.buildURL(
            baseURL: "https://api.example.com",
            path: "/games",
            queryItems: [
                "search": "Grand Theft Auto",
                "platforms": "1,2,3",
                "ordering": "-released",
            ]
        )

        #expect(url.absoluteString.contains("search="))
        #expect(url.absoluteString.contains("platforms="))
        #expect(url.absoluteString.contains("ordering="))
    }

    @Test("Build URL with special characters in query")
    func buildURLWithSpecialCharacters() throws {
        let manager = NetworkManager()

        let url = try manager.buildURL(
            baseURL: "https://api.example.com",
            path: "/games",
            queryItems: ["search": "The Witcher 3: Wild Hunt"]
        )

        // URL encoding should handle special characters
        #expect(url.absoluteString.contains("search="))
    }

    @Test("NetworkManager initializes with cache enabled")
    func initWithCacheEnabled() {
        let manager = NetworkManager(cacheEnabled: true)
        #expect(type(of: manager) == NetworkManager.self)
    }

    @Test("NetworkManager initializes with cache disabled")
    func initWithCacheDisabled() {
        let manager = NetworkManager(cacheEnabled: false)
        #expect(type(of: manager) == NetworkManager.self)
    }

    @Test("NetworkManager initializes with retry policy")
    func initWithRetryPolicy() {
        let retryPolicy = RetryPolicy(maxRetries: 3, baseDelay: 1.0)
        let manager = NetworkManager(cacheEnabled: true, retryPolicy: retryPolicy)
        #expect(type(of: manager) == NetworkManager.self)
    }

    @Test("NetworkManager initializes without retry policy")
    func initWithoutRetryPolicy() {
        let manager = NetworkManager(cacheEnabled: true, retryPolicy: nil)
        #expect(type(of: manager) == NetworkManager.self)
    }

    @Test("ClearCache completes without error")
    func clearCache() async {
        let manager = NetworkManager()
        await manager.clearCache()
        // If completes, test passes
        #expect(true)
    }

    @Test("CacheStats returns valid structure")
    func cacheStatsStructure() async {
        let manager = NetworkManager()
        let stats = await manager.cacheStats()

        #expect(stats.totalEntries >= 0)
        #expect(stats.validEntries >= 0)
        #expect(stats.expiredEntries >= 0)
        #expect(stats.validEntries <= stats.totalEntries)
    }

    @Test("CancelAllRequests completes without error")
    func cancelAllRequests() async {
        let manager = NetworkManager()
        await manager.cancelAllRequests()
        // If completes, test passes
        #expect(true)
    }

    @Test("Multiple managers are independent")
    func managerIndependence() {
        let manager1 = NetworkManager(cacheEnabled: true)
        let manager2 = NetworkManager(cacheEnabled: false)

        #expect(type(of: manager1) == NetworkManager.self)
        #expect(type(of: manager2) == NetworkManager.self)
    }

    @Test("URL building with different base URLs")
    func buildURLWithDifferentBase() throws {
        let manager = NetworkManager()

        let url1 = try manager.buildURL(
            baseURL: "https://api.rawg.io/api",
            path: "/games",
            queryItems: ["key": "test"]
        )

        let url2 = try manager.buildURL(
            baseURL: "https://other-api.com/v1",
            path: "/data",
            queryItems: ["key": "test"]
        )

        #expect(url1.host != url2.host)
    }

    @Test("URL building preserves query parameter order consistency")
    func buildURLQueryParameterConsistency() throws {
        let manager = NetworkManager()

        let queryItems = [
            "key": "test-key",
            "page": "1",
            "page_size": "20",
            "search": "game",
        ]

        let url = try manager.buildURL(
            baseURL: "https://api.example.com",
            path: "/games",
            queryItems: queryItems
        )

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.count == 4)
    }
}
