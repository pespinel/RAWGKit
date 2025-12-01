//
//  Tag.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//


/// Tag information
public struct Tag: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let language: String?
    public let gamesCount: Int?

    public init(
        id: Int,
        name: String,
        slug: String,
        language: String? = nil,
        gamesCount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.language = language
        self.gamesCount = gamesCount
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, language
        case gamesCount = "games_count"
    }
}