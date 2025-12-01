//
//  GenreDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//


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
