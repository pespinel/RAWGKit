//
// CacheManager.swift
// RAWGKit
//

import Foundation

/// Simple in-memory cache for API responses
public actor CacheManager {
    private var cache: [String: CacheEntry] = [:]
    private let defaultTTL: TimeInterval = 300 // 5 minutes

    struct CacheEntry {
        let data: Data
        let timestamp: Date
        let ttl: TimeInterval

        var isExpired: Bool {
            Date().timeIntervalSince(timestamp) > ttl
        }
    }

    /// Get cached data for a URL
    func get(for url: URL) -> Data? {
        let key = url.absoluteString
        guard let entry = cache[key], !entry.isExpired else {
            cache.removeValue(forKey: key)
            return nil
        }
        return entry.data
    }

    /// Set cached data for a URL
    func set(_ data: Data, for url: URL, ttl: TimeInterval? = nil) {
        let key = url.absoluteString
        let entry = CacheEntry(
            data: data,
            timestamp: Date(),
            ttl: ttl ?? defaultTTL
        )
        cache[key] = entry
    }

    /// Clear all cached data
    func clear() {
        cache.removeAll()
    }

    /// Remove expired entries
    func cleanExpired() {
        cache = cache.filter { !$0.value.isExpired }
    }

    /// Get cache statistics
    var stats: CacheStats {
        CacheStats(
            totalEntries: cache.count,
            validEntries: cache.values.filter { !$0.isExpired }.count,
            expiredEntries: cache.values.filter(\.isExpired).count
        )
    }

    public struct CacheStats: Sendable {
        public let totalEntries: Int
        public let validEntries: Int
        public let expiredEntries: Int
    }
}
