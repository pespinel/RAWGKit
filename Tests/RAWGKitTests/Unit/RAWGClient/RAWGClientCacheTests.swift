import Foundation
@testable import RAWGKit
import Testing

/// Test suite for RAWGClient cache control
@Suite("RAWGClient Cache Tests")
struct RAWGClientCacheTests {
    @Test("clearCache calls network manager")
    func clearCacheCallsNetworkManager() async {
        let mock = MockNetworkManager()
        let client = RAWGClient(apiKey: "test", networkManager: mock)

        await client.clearCache()

        let count = await mock.clearCacheCallCount
        #expect(count == 1)
    }

    @Test("cacheStats returns stats from network manager")
    func cacheStatsReturnsFromNetworkManager() async {
        let mock = MockNetworkManager()
        await mock.setMockCacheStats(
            CacheManager.CacheStats(
                totalEntries: 25,
                validEntries: 20,
                expiredEntries: 5
            )
        )

        let client = RAWGClient(apiKey: "test", networkManager: mock)
        let stats = await client.cacheStats()

        #expect(stats.totalEntries == 25)
        #expect(stats.validEntries == 20)
        #expect(stats.expiredEntries == 5)
    }
}
