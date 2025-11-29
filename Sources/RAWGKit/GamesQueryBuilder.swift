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

    /// Filter by parent platform IDs
    public func parentPlatforms(_ value: [Int]) -> Self {
        var builder = self
        builder.parentPlatforms = value
        return builder
    }

    /// Filter by genre IDs
    public func genres(_ value: [Int]) -> Self {
        var builder = self
        builder.genres = value
        return builder
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

    /// Filter by update date range
    public func updated(_ value: String) -> Self {
        var builder = self
        builder.updated = value
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
