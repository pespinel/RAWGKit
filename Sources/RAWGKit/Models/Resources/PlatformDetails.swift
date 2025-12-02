//
//  PlatformDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

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
