//
// GameDetails.swift
// RAWGKit
//

import Foundation

/// Represents detailed game information from the RAWG API.
///
/// This model contains comprehensive game data including descriptions,
/// social media metrics, publishers, developers, and multimedia content.
public struct GameDetail: Codable, Identifiable, Sendable {
    /// Unique identifier for the game.
    public let id: Int

    /// Display name of the game.
    public let name: String

    /// URL-friendly identifier derived from the game name.
    public let slug: String

    /// Original name of the game (if different from localized name).
    public let nameOriginal: String?

    /// HTML-formatted game description.
    public let description: String?

    /// Plain text game description.
    public let descriptionRaw: String?

    /// Metacritic score (0-100).
    public let metacritic: Int?

    /// Release date in ISO 8601 format (YYYY-MM-DD).
    public let released: String?

    /// Whether the release date is to be announced.
    public let tba: Bool

    /// Last update timestamp in ISO 8601 format.
    public let updated: String?

    /// URL to the game's primary background image.
    public let backgroundImage: String?

    /// URL to an additional background image.
    public let backgroundImageAdditional: String?

    /// Official website URL.
    public let website: String?

    /// Average rating from 0.0 to 5.0.
    public let rating: Double

    /// Maximum rating category (1-5).
    public let ratingTop: Int?

    /// Total number of ratings submitted.
    public let ratingsCount: Int?

    /// Breakdown of ratings by category.
    public let ratings: [Rating]?

    /// Average playtime in hours.
    public let playtime: Int?

    /// Platforms the game is available on.
    public let platforms: [PlatformInfo]?

    /// Genres the game belongs to.
    public let genres: [Genre]?

    /// Tags associated with the game.
    public let tags: [Tag]?

    /// Game publishers.
    public let publishers: [Publisher]?

    /// Game developers.
    public let developers: [Developer]?

    /// ESRB rating information.
    public let esrbRating: ESRBRating?

    /// Featured video clip.
    public let clip: Clip?

    /// Reddit community URL.
    public let redditUrl: String?

    /// Reddit community name.
    public let redditName: String?

    /// Reddit community description.
    public let redditDescription: String?

    /// Number of Reddit posts.
    public let redditCount: Int?

    /// Number of Twitch streams.
    public let twitchCount: Int?

    /// Number of YouTube videos.
    public let youtubeCount: Int?

    /// Alternative names for the game.
    public let alternativeNames: [String]?

    /// Creates a new detailed game instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the game.
    ///   - name: Display name of the game.
    ///   - slug: URL-friendly identifier.
    ///   - nameOriginal: Original name of the game.
    ///   - description: HTML-formatted game description.
    ///   - descriptionRaw: Plain text game description.
    ///   - metacritic: Metacritic score (0-100).
    ///   - released: Release date in ISO 8601 format.
    ///   - tba: Whether the release date is TBA.
    ///   - updated: Last update timestamp.
    ///   - backgroundImage: URL to primary background image.
    ///   - backgroundImageAdditional: URL to additional background image.
    ///   - website: Official website URL.
    ///   - rating: Average rating from 0.0 to 5.0.
    ///   - ratingTop: Maximum rating category.
    ///   - ratingsCount: Total number of ratings.
    ///   - ratings: Breakdown of ratings by category.
    ///   - playtime: Average playtime in hours.
    ///   - platforms: Platforms available on.
    ///   - genres: Genres the game belongs to.
    ///   - tags: Associated tags.
    ///   - publishers: Game publishers.
    ///   - developers: Game developers.
    ///   - esrbRating: ESRB rating information.
    ///   - clip: Featured video clip.
    ///   - redditUrl: Reddit community URL.
    ///   - redditName: Reddit community name.
    ///   - redditDescription: Reddit community description.
    ///   - redditCount: Number of Reddit posts.
    ///   - twitchCount: Number of Twitch streams.
    ///   - youtubeCount: Number of YouTube videos.
    ///   - alternativeNames: Alternative names for the game.
    public init(
        id: Int,
        name: String,
        slug: String,
        nameOriginal: String? = nil,
        description: String? = nil,
        descriptionRaw: String? = nil,
        metacritic: Int? = nil,
        released: String? = nil,
        tba: Bool = false,
        updated: String? = nil,
        backgroundImage: String? = nil,
        backgroundImageAdditional: String? = nil,
        website: String? = nil,
        rating: Double,
        ratingTop: Int? = nil,
        ratingsCount: Int? = nil,
        ratings: [Rating]? = nil,
        playtime: Int? = nil,
        platforms: [PlatformInfo]? = nil,
        genres: [Genre]? = nil,
        tags: [Tag]? = nil,
        publishers: [Publisher]? = nil,
        developers: [Developer]? = nil,
        esrbRating: ESRBRating? = nil,
        clip: Clip? = nil,
        redditUrl: String? = nil,
        redditName: String? = nil,
        redditDescription: String? = nil,
        redditCount: Int? = nil,
        twitchCount: Int? = nil,
        youtubeCount: Int? = nil,
        alternativeNames: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.nameOriginal = nameOriginal
        self.description = description
        self.descriptionRaw = descriptionRaw
        self.metacritic = metacritic
        self.released = released
        self.tba = tba
        self.updated = updated
        self.backgroundImage = backgroundImage
        self.backgroundImageAdditional = backgroundImageAdditional
        self.website = website
        self.rating = rating
        self.ratingTop = ratingTop
        self.ratingsCount = ratingsCount
        self.ratings = ratings
        self.playtime = playtime
        self.platforms = platforms
        self.genres = genres
        self.tags = tags
        self.publishers = publishers
        self.developers = developers
        self.esrbRating = esrbRating
        self.clip = clip
        self.redditUrl = redditUrl
        self.redditName = redditName
        self.redditDescription = redditDescription
        self.redditCount = redditCount
        self.twitchCount = twitchCount
        self.youtubeCount = youtubeCount
        self.alternativeNames = alternativeNames
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, metacritic, released, tba, updated, website, rating
        case playtime, platforms, genres, tags, publishers, developers, clip
        case nameOriginal = "name_original"
        case description
        case descriptionRaw = "description_raw"
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case ratingTop = "rating_top"
        case ratingsCount = "ratings_count"
        case ratings
        case esrbRating = "esrb_rating"
        case redditUrl = "reddit_url"
        case redditName = "reddit_name"
        case redditDescription = "reddit_description"
        case redditCount = "reddit_count"
        case twitchCount = "twitch_count"
        case youtubeCount = "youtube_count"
        case alternativeNames = "alternative_names"
    }

    /// Returns true if the game has a high rating (4.0+)
    public var isHighlyRated: Bool {
        rating >= 4.0
    }

    /// Returns platform names as a comma-separated string
    public var platformNames: String {
        platforms?.map(\.platform.name).joined(separator: ", ") ?? "Unknown"
    }

    /// Returns genre names as a comma-separated string
    public var genreNames: String {
        genres?.map(\.name).joined(separator: ", ") ?? "Unknown"
    }
}
