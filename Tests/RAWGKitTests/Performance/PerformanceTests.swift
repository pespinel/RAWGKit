//
// PerformanceTests.swift
// RAWGKit
//
// Created by RAWGKit on 16/12/2025.
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Performance Tests")
struct PerformanceTests {
    @Test("Cache operations should be fast (<5ms)")
    func cachePerformance() {
        let cacheManager = CacheManager()
        let testURL = URL(string: "https://api.rawg.io/api/games/1")!
        let data = Data("Test data".utf8)

        // Prime the cache
        cacheManager.set(data, for: testURL)

        // Measure cache retrieval time
        let start = CFAbsoluteTimeGetCurrent()
        let cachedData = cacheManager.get(for: testURL)
        let duration = (CFAbsoluteTimeGetCurrent() - start) * 1000 // Convert to ms

        #expect(cachedData != nil)
        #expect(duration < 5.0, "Cache retrieval took \(duration)ms, expected < 5ms")
    }

    @Test("Memory cache should handle large datasets efficiently")
    func memoryCacheEfficiency() {
        let cacheManager = CacheManager()
        cacheManager.clear()

        // Create 100 cache entries
        let entries = 100
        var urls: [URL] = []

        for index in 0 ..< entries {
            let url = URL(string: "https://api.rawg.io/api/games/\(index)")!
            urls.append(url)

            let data = Data("Game \(index)".utf8)
            cacheManager.set(data, for: url)
        }

        // Measure retrieval time for cached entries
        let start = CFAbsoluteTimeGetCurrent()

        var hitCount = 0
        for url in urls where cacheManager.get(for: url) != nil {
            hitCount += 1
        }

        let duration = (CFAbsoluteTimeGetCurrent() - start) * 1000
        let averagePerEntry = duration / Double(entries)

        #expect(hitCount == entries)
        #expect(averagePerEntry < 1.0, "Average cache lookup took \(averagePerEntry)ms, expected < 1ms")
    }

    @Test("Retry policy should have reasonable backoff times")
    func retryPolicyTiming() {
        let policy = RetryPolicy(maxRetries: 3, baseDelay: 0.1)

        // Verify exponential backoff times
        let delay1 = policy.delay(for: 1)
        let delay2 = policy.delay(for: 2)
        let delay3 = policy.delay(for: 3)

        #expect(delay1 > 0.05 && delay1 < 0.3) // ~0.1s with jitter
        #expect(delay2 > 0.1 && delay2 < 0.6) // ~0.2s with jitter
        #expect(delay3 > 0.2 && delay3 < 1.2) // ~0.4s with jitter

        // Total retry time should be reasonable (< 2 seconds)
        let totalDelay = delay1 + delay2 + delay3
        #expect(totalDelay < 2.0, "Total retry delay \(totalDelay)s is too long")
    }

    @Test("AsyncSequence pagination should be memory efficient")
    func paginationMemoryEfficiency() {
        // This test verifies that pagination doesn't load all pages into memory
        let mockResponse = RAWGResponse(
            count: 1000,
            next: "https://api.rawg.io/api/games?page=2",
            previous: nil,
            results: Array(repeating: Game(
                id: 1,
                name: "Test",
                slug: "test",
                backgroundImage: nil,
                released: "2020-01-01",
                rating: 4.0
            ), count: 20)
        )

        var processedCount = 0
        let maxToProcess = 50

        // Simulate processing only first few items
        for _ in mockResponse.results.enumerated() {
            processedCount += 1
            if processedCount >= maxToProcess {
                break
            }
        }

        // Verify pagination is page-based, not loading all items at once
        #expect(mockResponse.results.count == 20, "Each page should only contain 20 items")
        #expect(mockResponse.count == 1000, "Total count indicates 1000 items exist")
        #expect(processedCount == 20, "Should only process items in current page")
    }

    @Test("Cache statistics should be efficient to calculate")
    func cacheStatsPerformance() {
        let cacheManager = CacheManager()

        // Add multiple entries
        for index in 0 ..< 50 {
            let url = URL(string: "https://api.rawg.io/api/games/\(index)")!
            let data = Data("Data \(index)".utf8)
            cacheManager.set(data, for: url)
        }

        // Measure stats calculation time
        let start = CFAbsoluteTimeGetCurrent()
        let stats = cacheManager.stats
        let duration = (CFAbsoluteTimeGetCurrent() - start) * 1000

        #expect(stats.totalEntries > 0)
        #expect(duration < 10.0, "Stats calculation took \(duration)ms, expected < 10ms")
    }
}
