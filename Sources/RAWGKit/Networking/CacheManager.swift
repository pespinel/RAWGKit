//
// CacheManager.swift
// RAWGKit
//

import Foundation

/// In-memory cache for API responses using NSCache for automatic memory management.
///
/// `CacheManager` is an actor that provides thread-safe caching with automatic memory management
/// and TTL-based expiration. Actor isolation ensures safe concurrent access without manual locking.
public actor CacheManager {
    private let cache = NSCache<NSString, CacheEntry>()
    private var keys = Set<String>()
    private let defaultTTL: TimeInterval

    /// Cache entry wrapper for NSCache with TTL support
    private final class CacheEntry: NSObject {
        let data: Data
        let expirationDate: Date

        init(data: Data, ttl: TimeInterval) {
            self.data = data
            self.expirationDate = Date().addingTimeInterval(ttl)
            super.init()
        }

        var isExpired: Bool {
            Date() > expirationDate
        }
    }

    /// Creates a new CacheManager
    /// - Parameters:
    ///   - countLimit: Maximum number of entries (0 = no limit, uses system default)
    ///   - totalCostLimit: Maximum total cost in bytes (0 = no limit, uses system default)
    ///   - defaultTTL: Default time-to-live for entries in seconds (default: 5 minutes)
    public init(
        countLimit: Int = RAWGConstants.defaultCacheLimit,
        totalCostLimit: Int = 10 * 1024 * 1024,
        defaultTTL: TimeInterval = RAWGConstants.defaultCacheTTL
    ) {
        self.defaultTTL = defaultTTL
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    /// Get cached data for a URL
    /// - Parameter url: The URL to look up
    /// - Returns: Cached data if available and not expired, nil otherwise
    public func get(for url: URL) -> Data? {
        let key = url.absoluteString as NSString

        guard let entry = cache.object(forKey: key) else {
            return nil
        }

        if entry.isExpired {
            cache.removeObject(forKey: key)
            keys.remove(url.absoluteString)
            return nil
        }

        return entry.data
    }

    /// Set cached data for a URL
    /// - Parameters:
    ///   - data: Data to cache
    ///   - url: URL as cache key
    ///   - ttl: Time-to-live in seconds (uses default if nil)
    public func set(_ data: Data, for url: URL, ttl: TimeInterval? = nil) {
        let key = url.absoluteString as NSString
        let entry = CacheEntry(data: data, ttl: ttl ?? defaultTTL)

        // Use data size as cost for memory-based eviction
        cache.setObject(entry, forKey: key, cost: data.count)
        keys.insert(url.absoluteString)
    }

    /// Clear all cached data
    public func clear() {
        cache.removeAllObjects()
        keys.removeAll()
    }

    /// Remove expired entries
    public func cleanExpired() {
        let currentKeys = keys

        for keyString in currentKeys {
            let key = keyString as NSString
            if let entry = cache.object(forKey: key), entry.isExpired {
                cache.removeObject(forKey: key)
                keys.remove(keyString)
            }
        }
    }

    /// Get cache statistics
    public var stats: CacheStats {
        let currentKeys = keys

        var validCount = 0
        var expiredCount = 0

        for keyString in currentKeys {
            let key = keyString as NSString
            if let entry = cache.object(forKey: key) {
                if entry.isExpired {
                    expiredCount += 1
                } else {
                    validCount += 1
                }
            }
        }

        return CacheStats(
            totalEntries: validCount + expiredCount,
            validEntries: validCount,
            expiredEntries: expiredCount
        )
    }

    /// Cache statistics
    public struct CacheStats: Sendable {
        public let totalEntries: Int
        public let validEntries: Int
        public let expiredEntries: Int
    }
}
