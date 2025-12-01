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
