//
// Creator.swift
// RAWGKit
//

import Foundation

/// Creator/Person information
public struct Creator: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let image: String?
    public let imageBackground: String?
    public let gamesCount: Int?

    public init(
        id: Int,
        name: String,
        slug: String,
        image: String? = nil,
        imageBackground: String? = nil,
        gamesCount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.image = image
        self.imageBackground = imageBackground
        self.gamesCount = gamesCount
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case imageBackground = "image_background"
        case gamesCount = "games_count"
    }
}

/// Creator details with additional info
public struct CreatorDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let image: String?
    public let imageBackground: String?
    public let description: String?
    public let gamesCount: Int?
    public let reviewsCount: Int?
    public let rating: String?
    public let ratingTop: Int?
    public let updated: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        image: String? = nil,
        imageBackground: String? = nil,
        description: String? = nil,
        gamesCount: Int? = nil,
        reviewsCount: Int? = nil,
        rating: String? = nil,
        ratingTop: Int? = nil,
        updated: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.image = image
        self.imageBackground = imageBackground
        self.description = description
        self.gamesCount = gamesCount
        self.reviewsCount = reviewsCount
        self.rating = rating
        self.ratingTop = ratingTop
        self.updated = updated
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image, description, rating, updated
        case imageBackground = "image_background"
        case gamesCount = "games_count"
        case reviewsCount = "reviews_count"
        case ratingTop = "rating_top"
    }
}

/// Creator position/role
public struct CreatorRole: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
