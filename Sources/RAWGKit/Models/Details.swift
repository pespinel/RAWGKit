//
// Details.swift
// RAWGKit
//

import Foundation

/// Developer details with description
public struct DeveloperDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let gamesCount: Int?
    public let imageBackground: String?
    public let description: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

/// Publisher details with description
public struct PublisherDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let gamesCount: Int?
    public let imageBackground: String?
    public let description: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

/// Genre details with description
public struct GenreDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let gamesCount: Int?
    public let imageBackground: String?
    public let description: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

/// Tag details with description
public struct TagDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let gamesCount: Int?
    public let imageBackground: String?
    public let description: String?
    public let language: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil,
        language: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
        self.language = language
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, language
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

/// Platform details with description and additional info
public struct PlatformDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let gamesCount: Int?
    public let imageBackground: String?
    public let description: String?
    public let image: String?
    public let yearStart: Int?
    public let yearEnd: Int?

    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil,
        image: String? = nil,
        yearStart: Int? = nil,
        yearEnd: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
        self.image = image
        self.yearStart = yearStart
        self.yearEnd = yearEnd
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, image
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case yearStart = "year_start"
        case yearEnd = "year_end"
    }
}

/// Parent platform with child platforms
public struct ParentPlatform: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let platforms: [Platform]?

    public init(
        id: Int,
        name: String,
        slug: String,
        platforms: [Platform]? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.platforms = platforms
    }
}
