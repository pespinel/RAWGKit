//
// CacheManagerTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("CacheManager Tests")
struct CacheManagerTests {
    @Test("CacheManager stores and retrieves data")
    func cacheSetAndGet() async throws {
        let cache = CacheManager()
        let url = URL(string: "https://api.rawg.io/api/games")!
        let testData = Data("test data".utf8)

        await cache.set(testData, for: url)
        let retrieved = await cache.get(for: url)

        #expect(retrieved != nil)
        #expect(retrieved == testData)
    }

    @Test("CacheManager returns nil for non-existent entries")
    func cacheGetNonExistent() async throws {
        let cache = CacheManager()
        let url = URL(string: "https://api.rawg.io/api/games")!

        let retrieved = await cache.get(for: url)

        #expect(retrieved == nil)
    }

    @Test("CacheManager respects TTL")
    func cacheTTL() async throws {
        let cache = CacheManager()
        let url = URL(string: "https://api.rawg.io/api/games")!
        let testData = Data("test data".utf8)

        // Set with very short TTL
        await cache.set(testData, for: url, ttl: 0.1)

        // Should be available immediately
        var retrieved = await cache.get(for: url)
        #expect(retrieved != nil)

        // Wait for expiration
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15 seconds

        // Should be expired now
        retrieved = await cache.get(for: url)
        #expect(retrieved == nil)
    }

    @Test("CacheManager clears all entries")
    func cacheClear() async throws {
        let cache = CacheManager()
        let url1 = URL(string: "https://api.rawg.io/api/games")!
        let url2 = URL(string: "https://api.rawg.io/api/genres")!
        let testData = Data("test data".utf8)

        await cache.set(testData, for: url1)
        await cache.set(testData, for: url2)

        await cache.clear()

        let retrieved1 = await cache.get(for: url1)
        let retrieved2 = await cache.get(for: url2)

        #expect(retrieved1 == nil)
        #expect(retrieved2 == nil)
    }

    @Test("CacheManager provides correct statistics")
    func cacheStats() async throws {
        let cache = CacheManager()
        let url1 = URL(string: "https://api.rawg.io/api/games")!
        let url2 = URL(string: "https://api.rawg.io/api/genres")!
        let testData = Data("test data".utf8)

        // Initially empty
        var stats = await cache.stats
        #expect(stats.totalEntries == 0)
        #expect(stats.validEntries == 0)

        // Add entries
        await cache.set(testData, for: url1)
        await cache.set(testData, for: url2, ttl: 0.1)

        stats = await cache.stats
        #expect(stats.totalEntries == 2)
        #expect(stats.validEntries == 2)

        // Wait for one to expire
        try await Task.sleep(nanoseconds: 150_000_000)

        stats = await cache.stats
        #expect(stats.totalEntries == 2)
        #expect(stats.validEntries == 1)
        #expect(stats.expiredEntries == 1)
    }

    @Test("CacheManager cleans expired entries")
    func cacheCleanExpired() async throws {
        let cache = CacheManager()
        let url1 = URL(string: "https://api.rawg.io/api/games")!
        let url2 = URL(string: "https://api.rawg.io/api/genres")!
        let testData = Data("test data".utf8)

        await cache.set(testData, for: url1, ttl: 0.1)
        await cache.set(testData, for: url2, ttl: 300)

        // Wait for one to expire
        try await Task.sleep(nanoseconds: 150_000_000)

        await cache.cleanExpired()

        let stats = await cache.stats
        #expect(stats.totalEntries == 1)
        #expect(stats.validEntries == 1)
    }
}
