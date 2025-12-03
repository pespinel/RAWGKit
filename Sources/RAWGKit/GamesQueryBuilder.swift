//
// GamesQueryBuilder.swift
// RAWGKit
//

import Foundation

/// Builder pattern for constructing complex game queries
public struct GamesQueryBuilder: Sendable {
    private var page: Int = 1
    private var pageSize: Int = 20
    private var search: String?
    private var searchPrecise: Bool?
    private var searchExact: Bool?
    private var ordering: String?
    private var platforms: [Int]?
    private var parentPlatforms: [Int]?
    private var genres: [Int]?
    private var tags: [Int]?
    private var developers: String?
    private var publishers: String?
    private var stores: [Int]?
    private var creators: String?
    private var dates: String?
    private var updated: String?
    private var metacritic: String?
    private var excludeAdditions: Bool?
    private var excludeParents: Bool?
    private var excludeGameSeries: Bool?

    /// Shared date formatter for RAWG API date format (yyyy-MM-dd)
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()

    public init() {}

    /// Set page number
    public func page(_ value: Int) -> Self {
        var builder = self
        builder.page = value
        return builder
    }

    /// Set page size (max 40)
    public func pageSize(_ value: Int) -> Self {
        var builder = self
        builder.pageSize = min(value, 40)
        return builder
    }

    /// Set search query
    public func search(_ value: String) -> Self {
        var builder = self
        builder.search = value
        return builder
    }

    /// Disable fuzzy search
    public func searchPrecise(_ value: Bool = true) -> Self {
        var builder = self
        builder.searchPrecise = value
        return builder
    }

    /// Mark search as exact
    public func searchExact(_ value: Bool = true) -> Self {
        var builder = self
        builder.searchExact = value
        return builder
    }

    /// Set ordering field (e.g., "name", "-released", "rating", "-metacritic")
    public func ordering(_ value: String) -> Self {
        var builder = self
        builder.ordering = value
        return builder
    }

    /// Set ordering using type-safe enum
    /// - Parameter value: Ordering option
    /// - Returns: Builder with ordering applied
    ///
    /// Example:
    /// ```swift
    /// .ordering(.metacriticDescending)
    /// ```
    public func ordering(_ value: GameOrdering) -> Self {
        ordering(value.rawValue)
    }

    /// Sort by name ascending
    public func orderByName() -> Self {
        ordering("name")
    }

    /// Sort by release date descending (newest first)
    public func orderByNewest() -> Self {
        ordering("-released")
    }

    /// Sort by rating descending (highest first)
    public func orderByRating() -> Self {
        ordering("-rating")
    }

    /// Sort by Metacritic score descending
    public func orderByMetacritic() -> Self {
        ordering("-metacritic")
    }

    /// Filter by platform IDs
    public func platforms(_ value: [Int]) -> Self {
        var builder = self
        builder.platforms = value
        return builder
    }

    /// Filter by known platforms (type-safe)
    /// - Parameter value: Array of known platform enums
    /// - Returns: Builder with platforms filter applied
    ///
    /// Example:
    /// ```swift
    /// .platforms([.pc, .playStation5, .xboxSeriesX])
    /// ```
    public func platforms(_ value: [KnownPlatform]) -> Self {
        platforms(value.map(\.rawValue))
    }

    /// Filter by parent platform IDs
    public func parentPlatforms(_ value: [Int]) -> Self {
        var builder = self
        builder.parentPlatforms = value
        return builder
    }

    /// Filter by known parent platforms (type-safe)
    /// - Parameter value: Array of known parent platform enums
    /// - Returns: Builder with parent platforms filter applied
    ///
    /// Example:
    /// ```swift
    /// .parentPlatforms([.playStation, .xbox, .nintendo])
    /// ```
    public func parentPlatforms(_ value: [KnownParentPlatform]) -> Self {
        parentPlatforms(value.map(\.rawValue))
    }

    /// Filter by genre IDs
    public func genres(_ value: [Int]) -> Self {
        var builder = self
        builder.genres = value
        return builder
    }

    /// Filter by known genres (type-safe)
    /// - Parameter value: Array of known genre enums
    /// - Returns: Builder with genres filter applied
    ///
    /// Example:
    /// ```swift
    /// .genres([.action, .rpg, .adventure])
    /// ```
    public func genres(_ value: [KnownGenre]) -> Self {
        genres(value.map(\.rawValue))
    }

    /// Filter by tag IDs
    public func tags(_ value: [Int]) -> Self {
        var builder = self
        builder.tags = value
        return builder
    }

    /// Filter by developers (IDs or slugs, comma-separated)
    public func developers(_ value: String) -> Self {
        var builder = self
        builder.developers = value
        return builder
    }

    /// Filter by publishers (IDs or slugs, comma-separated)
    public func publishers(_ value: String) -> Self {
        var builder = self
        builder.publishers = value
        return builder
    }

    /// Filter by store IDs
    public func stores(_ value: [Int]) -> Self {
        var builder = self
        builder.stores = value
        return builder
    }

    /// Filter by known stores (type-safe)
    /// - Parameter value: Array of known store enums
    /// - Returns: Builder with stores filter applied
    ///
    /// Example:
    /// ```swift
    /// .stores([.steam, .epicGames, .gog])
    /// ```
    public func stores(_ value: [KnownStore]) -> Self {
        stores(value.map(\.rawValue))
    }

    /// Filter by creators (IDs or slugs, comma-separated)
    public func creators(_ value: String) -> Self {
        var builder = self
        builder.creators = value
        return builder
    }

    /// Filter by release date range (format: "YYYY-MM-DD,YYYY-MM-DD")
    public func dates(_ value: String) -> Self {
        var builder = self
        builder.dates = value
        return builder
    }

    /// Filter by games released in a specific year
    public func year(_ value: Int) -> Self {
        dates("\(value)-01-01,\(value)-12-31")
    }

    /// Filter by games released in the current year
    public func releasedThisYear() -> Self {
        year(Calendar.current.component(.year, from: Date()))
    }

    /// Filter by games released between two dates (type-safe)
    /// - Parameters:
    ///   - startDate: Start of the date range
    ///   - endDate: End of the date range
    /// - Returns: Builder with date range filter applied
    ///
    /// Example:
    /// ```swift
    /// let start = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))!
    /// let end = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 31))!
    /// .releasedBetween(from: start, to: end)
    /// ```
    public func releasedBetween(from startDate: Date, to endDate: Date) -> Self {
        let start = Self.dateFormatter.string(from: startDate)
        let end = Self.dateFormatter.string(from: endDate)
        return dates("\(start),\(end)")
    }

    /// Filter by games released after a specific date
    /// - Parameter date: Start date (games released from this date onwards)
    /// - Returns: Builder with date filter applied
    public func releasedAfter(_ date: Date) -> Self {
        let start = Self.dateFormatter.string(from: date)
        let farFuture = Self.dateFormatter.string(from: Date.distantFuture)
        return dates("\(start),\(farFuture)")
    }

    /// Filter by games released before a specific date
    /// - Parameter date: End date (games released up to this date)
    /// - Returns: Builder with date filter applied
    public func releasedBefore(_ date: Date) -> Self {
        let end = Self.dateFormatter.string(from: date)
        return dates("1970-01-01,\(end)")
    }

    /// Filter by games released in the last N days
    /// - Parameter days: Number of days to look back
    /// - Returns: Builder with date filter applied
    ///
    /// Example:
    /// ```swift
    /// .releasedInLast(days: 30) // Games released in the last month
    /// ```
    public func releasedInLast(days: Int) -> Self {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
        return releasedBetween(from: start, to: end)
    }

    /// Filter by update date range
    public func updated(_ value: String) -> Self {
        var builder = self
        builder.updated = value
        return builder
    }

    /// Filter by games updated between two dates (type-safe)
    /// - Parameters:
    ///   - startDate: Start of the date range
    ///   - endDate: End of the date range
    /// - Returns: Builder with update date range filter applied
    public func updatedBetween(from startDate: Date, to endDate: Date) -> Self {
        let start = Self.dateFormatter.string(from: startDate)
        let end = Self.dateFormatter.string(from: endDate)
        var builder = self
        builder.updated = "\(start),\(end)"
        return builder
    }

    /// Filter by Metacritic score range (format: "min,max")
    public func metacritic(_ value: String) -> Self {
        var builder = self
        builder.metacritic = value
        return builder
    }

    /// Filter by minimum Metacritic score
    public func metacriticMin(_ value: Int) -> Self {
        metacritic("\(value),100")
    }

    /// Filter by Metacritic score range (type-safe)
    /// - Parameters:
    ///   - min: Minimum score (0-100)
    ///   - max: Maximum score (0-100)
    /// - Returns: Builder with Metacritic filter applied
    ///
    /// Example:
    /// ```swift
    /// .metacritic(min: 80, max: 100) // Only highly rated games
    /// ```
    public func metacritic(min: Int, max: Int) -> Self {
        let clampedMin = Swift.min(Swift.max(min, 0), 100)
        let clampedMax = Swift.min(Swift.max(max, 0), 100)
        return metacritic("\(clampedMin),\(clampedMax)")
    }

    /// Exclude DLC and additions
    public func excludeAdditions(_ value: Bool = true) -> Self {
        var builder = self
        builder.excludeAdditions = value
        return builder
    }

    /// Exclude games that have additions
    public func excludeParents(_ value: Bool = true) -> Self {
        var builder = self
        builder.excludeParents = value
        return builder
    }

    /// Exclude games in a series
    public func excludeGameSeries(_ value: Bool = true) -> Self {
        var builder = self
        builder.excludeGameSeries = value
        return builder
    }

    /// Execute the query using the provided client
    public func execute(with client: RAWGClient) async throws -> GamesResponse {
        try await client.fetchGames(
            page: page,
            pageSize: pageSize,
            search: search,
            searchPrecise: searchPrecise,
            searchExact: searchExact,
            ordering: ordering,
            platforms: platforms,
            parentPlatforms: parentPlatforms,
            genres: genres,
            tags: tags,
            developers: developers,
            publishers: publishers,
            stores: stores,
            creators: creators,
            dates: dates,
            updated: updated,
            metacritic: metacritic,
            excludeAdditions: excludeAdditions,
            excludeParents: excludeParents,
            excludeGameSeries: excludeGameSeries
        )
    }
}

// MARK: - RAWGClient Extension

public extension RAWGClient {
    /// Creates a new games query builder
    func gamesQuery() -> GamesQueryBuilder {
        GamesQueryBuilder()
    }
}
