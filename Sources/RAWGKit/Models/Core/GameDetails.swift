//
// GameDetails.swift
// RAWGKit
//

import Foundation

/// Detailed game information
public struct GameDetail: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let nameOriginal: String?
    public let description: String?
    public let descriptionRaw: String?
    public let metacritic: Int?
    public let released: String?
    public let tba: Bool
    public let updated: String?
    public let backgroundImage: String?
    public let backgroundImageAdditional: String?
    public let website: String?
    public let rating: Double
    public let ratingTop: Int?
    public let ratingsCount: Int?
    public let ratings: [Rating]?
    public let playtime: Int?
    public let platforms: [PlatformInfo]?
    public let genres: [Genre]?
    public let tags: [Tag]?
    public let publishers: [Publisher]?
    public let developers: [Developer]?
    public let esrbRating: ESRBRating?
    public let clip: Clip?
    public let redditUrl: String?
    public let redditName: String?
    public let redditDescription: String?
    public let redditCount: Int?
    public let twitchCount: Int?
    public let youtubeCount: Int?
    public let alternativeNames: [String]?

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
