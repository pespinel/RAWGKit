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
