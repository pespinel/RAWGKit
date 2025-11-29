//
// Genre.swift
// RAWGKit
//

import Foundation

/// Game genre information
public struct Genre: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let gamesCount: Int?
    public let imageBackground: String?

    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
