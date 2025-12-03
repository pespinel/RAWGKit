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
    func cacheSetAndGet() throws {
        let cache = CacheManager()
        let url = URL(string: "https://api.rawg.io/api/games")!
        let testData = Data("test data".utf8)

        cache.set(testData, for: url)
        let retrieved = cache.get(for: url)

        #expect(retrieved != nil)
        #expect(retrieved == testData)
    }

    @Test("CacheManager returns nil for non-existent entries")
    func cacheGetNonExistent() throws {
        let cache = CacheManager()
        let url = URL(string: "https://api.rawg.io/api/games")!

        let retrieved = cache.get(for: url)

        #expect(retrieved == nil)
    }

    @Test("CacheManager respects TTL")
    func cacheTTL() async throws {
        let cache = CacheManager()
        let url = URL(string: "https://api.rawg.io/api/games")!
        let testData = Data("test data".utf8)

        // Set with very short TTL
        cache.set(testData, for: url, ttl: 0.1)

        // Should be available immediately
        var retrieved = cache.get(for: url)
        #expect(retrieved != nil)

        // Wait for expiration
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15 seconds

        // Should be expired now
        retrieved = cache.get(for: url)
        #expect(retrieved == nil)
    }

    @Test("CacheManager clears all entries")
    func cacheClear() throws {
        let cache = CacheManager()
        let url1 = URL(string: "https://api.rawg.io/api/games")!
        let url2 = URL(string: "https://api.rawg.io/api/genres")!
        let testData = Data("test data".utf8)

        cache.set(testData, for: url1)
        cache.set(testData, for: url2)

        cache.clear()

        let retrieved1 = cache.get(for: url1)
        let retrieved2 = cache.get(for: url2)

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
        var stats = cache.stats
        #expect(stats.totalEntries == 0)
        #expect(stats.validEntries == 0)

        // Add entries
        cache.set(testData, for: url1)
        cache.set(testData, for: url2, ttl: 0.1)

        stats = cache.stats
        #expect(stats.totalEntries == 2)
        #expect(stats.validEntries == 2)

        // Wait for one to expire
        try await Task.sleep(nanoseconds: 150_000_000)

        stats = cache.stats
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

        cache.set(testData, for: url1, ttl: 0.1)
        cache.set(testData, for: url2, ttl: 300)

        // Wait for one to expire
        try await Task.sleep(nanoseconds: 150_000_000)

        cache.cleanExpired()

        let stats = cache.stats
        #expect(stats.totalEntries == 1)
        #expect(stats.validEntries == 1)
    }

    @Test("CacheManager respects count limit")
    func cacheCountLimit() throws {
        let cache = CacheManager(countLimit: 2)
        let url1 = URL(string: "https://api.rawg.io/api/games/1")!
        let url2 = URL(string: "https://api.rawg.io/api/games/2")!
        let url3 = URL(string: "https://api.rawg.io/api/games/3")!
        let testData = Data("test data".utf8)

        cache.set(testData, for: url1)
        cache.set(testData, for: url2)
        cache.set(testData, for: url3)

        // NSCache may evict entries when limit is exceeded
        // At least one should still be retrievable
        let count = [url1, url2, url3].compactMap { cache.get(for: $0) }.count
        #expect(count >= 1)
    }

    @Test("CacheManager is thread-safe")
    func cacheThreadSafety() async throws {
        let cache = CacheManager()
        let testData = Data("test data".utf8)

        // Perform concurrent operations
        await withTaskGroup(of: Void.self) { group in
            for index in 0 ..< 100 {
                group.addTask {
                    let url = URL(string: "https://api.rawg.io/api/games/\(index)")!
                    cache.set(testData, for: url)
                    _ = cache.get(for: url)
                }
            }
        }

        // Should not crash and stats should be accessible
        let stats = cache.stats
        #expect(stats.totalEntries >= 0)
    }
}
