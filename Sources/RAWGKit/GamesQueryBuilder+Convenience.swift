//
// GamesQueryBuilder+Convenience.swift
// RAWGKit
//

import Foundation

// MARK: - Platform & Genre Extensions

public extension GamesQueryBuilder {
    /// Filter by Platform.Popular constants
    /// - Parameter popularPlatforms: Array of Platform.Popular constants
    /// - Returns: Builder with platforms filter applied
    ///
    /// Example:
    /// ```swift
    /// .platformsPopular([Platform.Popular.pc, Platform.Popular.playStation5])
    /// ```
    func platformsPopular(_ popularPlatforms: [Platform]) -> Self {
        platforms(popularPlatforms.map(\.id))
    }

    /// Filter by Genre.Popular constants
    /// - Parameter popularGenres: Array of Genre.Popular constants
    /// - Returns: Builder with genres filter applied
    ///
    /// Example:
    /// ```swift
    /// .genresPopular([Genre.Popular.action, Genre.Popular.rpg])
    /// ```
    func genresPopular(_ popularGenres: [Genre]) -> Self {
        genres(popularGenres.map(\.id))
    }
}

// MARK: - Convenience Query Methods

public extension GamesQueryBuilder {
    /// Popular games from the last 30 days, sorted by rating
    /// - Returns: Builder configured for popular recent games
    static func popularGames() -> Self {
        Self()
            .releasedInLast(days: 30)
            .metacriticMin(75)
            .orderByRating()
            .pageSize(40)
    }

    /// New releases from the last 7 days
    /// - Returns: Builder configured for new releases
    static func newReleases() -> Self {
        Self()
            .releasedInLast(days: 7)
            .orderByNewest()
            .pageSize(40)
    }

    /// Upcoming games in the next 180 days
    /// - Returns: Builder configured for upcoming games
    static func upcomingGames() -> Self {
        let now = Date()
        let future = Calendar.current.date(byAdding: .day, value: 180, to: now) ?? now
        return Self()
            .releasedBetween(from: now, to: future)
            .ordering("released")
            .pageSize(40)
    }

    /// Top-rated games of all time
    /// - Returns: Builder configured for highest-rated games
    static func topRated() -> Self {
        Self()
            .metacriticMin(90)
            .orderByMetacritic()
            .pageSize(40)
    }

    /// Games released this year
    /// - Returns: Builder configured for current year releases
    static func thisYear() -> Self {
        Self()
            .releasedThisYear()
            .orderByNewest()
            .pageSize(40)
    }

    /// Trending games (highly rated recent releases)
    /// - Returns: Builder configured for trending games
    static func trending() -> Self {
        Self()
            .releasedInLast(days: 60)
            .metacriticMin(70)
            .orderByRating()
            .pageSize(40)
    }
}

// MARK: - RAWGClient Convenience Methods

public extension RAWGClient {
    /// Fetch popular games from the last 30 days
    func fetchPopularGames() async throws -> GamesResponse {
        try await GamesQueryBuilder.popularGames().execute(with: self)
    }

    /// Fetch new game releases from the last 7 days
    func fetchNewReleases() async throws -> GamesResponse {
        try await GamesQueryBuilder.newReleases().execute(with: self)
    }

    /// Fetch upcoming games in the next 180 days
    func fetchUpcomingGames() async throws -> GamesResponse {
        try await GamesQueryBuilder.upcomingGames().execute(with: self)
    }

    /// Fetch top-rated games of all time
    func fetchTopRated() async throws -> GamesResponse {
        try await GamesQueryBuilder.topRated().execute(with: self)
    }

    /// Fetch games released this year
    func fetchThisYear() async throws -> GamesResponse {
        try await GamesQueryBuilder.thisYear().execute(with: self)
    }

    /// Fetch trending games (highly rated recent releases)
    func fetchTrendingGames() async throws -> GamesResponse {
        try await GamesQueryBuilder.trending().execute(with: self)
    }
}
