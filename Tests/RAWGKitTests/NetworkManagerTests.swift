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
}
