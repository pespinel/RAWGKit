//
// Game.swift
// RAWGKit
//

import Foundation

/// Represents a game in list views from the RAWG API.
///
/// This model contains essential game information typically shown in game listings,
/// including metadata, ratings, platforms, and visual assets.
public struct Game: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the game.
    public let id: Int

    /// Display name of the game.
    public let name: String

    /// URL-friendly identifier derived from the game name.
    public let slug: String

    /// URL to the game's background image.
    public let backgroundImage: String?

    /// Release date in ISO 8601 format (YYYY-MM-DD).
    public let released: String?

    /// Average rating from 0.0 to 5.0.
    public let rating: Double

    /// Maximum rating category (1-5).
    public let ratingTop: Int?

    /// Total number of ratings submitted.
    public let ratingsCount: Int?

    /// Metacritic score (0-100).
    public let metacritic: Int?

    /// Average playtime in hours.
    public let playtime: Int?

    /// Platforms the game is available on.
    public let platforms: [PlatformInfo]?

    /// Genres the game belongs to.
    public let genres: [Genre]?

    /// Tags associated with the game.
    public let tags: [Tag]?

    /// ESRB rating information (if available).
    public let esrbRating: ESRBRating?

    /// Preview screenshots of the game.
    public let shortScreenshots: [ShortScreenshot]?

    /// Creates a new game instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the game.
    ///   - name: Display name of the game.
    ///   - slug: URL-friendly identifier.
    ///   - backgroundImage: URL to the game's background image.
    ///   - released: Release date in ISO 8601 format.
    ///   - rating: Average rating from 0.0 to 5.0.
    ///   - ratingTop: Maximum rating category.
    ///   - ratingsCount: Total number of ratings.
    ///   - metacritic: Metacritic score (0-100).
    ///   - playtime: Average playtime in hours.
    ///   - platforms: Platforms the game is available on.
    ///   - genres: Genres the game belongs to.
    ///   - tags: Tags associated with the game.
    ///   - esrbRating: ESRB rating information.
    ///   - shortScreenshots: Preview screenshots.
    public init(
        id: Int,
        name: String,
        slug: String,
        backgroundImage: String? = nil,
        released: String? = nil,
        rating: Double,
        ratingTop: Int? = nil,
        ratingsCount: Int? = nil,
        metacritic: Int? = nil,
        playtime: Int? = nil,
        platforms: [PlatformInfo]? = nil,
        genres: [Genre]? = nil,
        tags: [Tag]? = nil,
        esrbRating: ESRBRating? = nil,
        shortScreenshots: [ShortScreenshot]? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.backgroundImage = backgroundImage
        self.released = released
        self.rating = rating
        self.ratingTop = ratingTop
        self.ratingsCount = ratingsCount
        self.metacritic = metacritic
        self.playtime = playtime
        self.platforms = platforms
        self.genres = genres
        self.tags = tags
        self.esrbRating = esrbRating
        self.shortScreenshots = shortScreenshots
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, rating, metacritic, playtime, platforms, genres, tags
        case backgroundImage = "background_image"
        case released
        case ratingTop = "rating_top"
        case ratingsCount = "ratings_count"
        case esrbRating = "esrb_rating"
        case shortScreenshots = "short_screenshots"
    }

    /// Returns true if the game has a high rating (4.0+)
    public var isHighlyRated: Bool {
        rating >= 4.0
    }

    /// Returns platform names as a comma-separated string
    public var platformNames: String {
        platforms?.prefix(3).map(\.platform.name).joined(separator: ", ") ?? "Unknown"
    }
}
