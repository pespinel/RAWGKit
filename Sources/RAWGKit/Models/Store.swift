//
// Store.swift
// RAWGKit
//

import Foundation

/// Store information
public struct Store: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let domain: String?
    public let gamesCount: Int?
    public let imageBackground: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        domain: String? = nil,
        gamesCount: Int? = nil,
        imageBackground: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.domain = domain
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

/// Store details with description
public struct StoreDetails: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let domain: String?
    public let gamesCount: Int?
    public let imageBackground: String?
    public let description: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        domain: String? = nil,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.domain = domain
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

/// Game store link
public struct GameStore: Codable, Identifiable, Sendable {
    public let id: Int
    public let gameId: Int?
    public let storeId: Int?
    public let url: String?
    public let store: Store?

    public init(
        id: Int,
        gameId: Int? = nil,
        storeId: Int? = nil,
        url: String? = nil,
        store: Store? = nil
    ) {
        self.id = id
        self.gameId = gameId
        self.storeId = storeId
        self.url = url
        self.store = store
    }

    enum CodingKeys: String, CodingKey {
        case id, url, store
        case gameId = "game_id"
        case storeId = "store_id"
    }
}
