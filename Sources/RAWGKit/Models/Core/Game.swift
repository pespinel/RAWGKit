//
// Game.swift
// RAWGKit
//

import Foundation

/// Game model for list views
public struct Game: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let backgroundImage: String?
    public let released: String?
    public let rating: Double
    public let ratingTop: Int?
    public let ratingsCount: Int?
    public let metacritic: Int?
    public let playtime: Int?
    public let platforms: [PlatformInfo]?
    public let genres: [Genre]?
    public let tags: [Tag]?
    public let esrbRating: ESRBRating?
    public let shortScreenshots: [ShortScreenshot]?

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
