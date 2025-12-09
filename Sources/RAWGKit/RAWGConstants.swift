//
// RAWGConstants.swift
// RAWGKit
//

import Foundation

/// Constants used throughout RAWGKit
public enum RAWGConstants {
    // MARK: - API Limits

    /// Maximum number of items that can be requested per page
    public static let maxPageSize = 40

    /// Default number of items per page
    public static let defaultPageSize = 20

    /// Minimum page number
    public static let minPage = 1

    // MARK: - Metacritic Scores

    /// Maximum Metacritic score
    public static let maxMetacriticScore = 100

    /// Minimum Metacritic score
    public static let minMetacriticScore = 0

    // MARK: - Cache

    /// Default cache TTL (Time To Live) in seconds - 5 minutes
    public static let defaultCacheTTL: TimeInterval = 300

    /// Maximum number of cached entries
    public static let defaultCacheLimit = 100

    // MARK: - Network

    /// Default request timeout in seconds
    public static let defaultRequestTimeout: TimeInterval = 30.0

    /// Default retry attempts for failed requests
    public static let defaultMaxRetries = 3
}
