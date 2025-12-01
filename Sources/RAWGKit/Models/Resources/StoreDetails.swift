//
//  StoreDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//


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