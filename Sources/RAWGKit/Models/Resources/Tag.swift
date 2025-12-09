//
//  Tag.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a user-defined game tag from the RAWG API.
///
/// Tags are community-defined labels describing game features, themes, or characteristics
/// (e.g., "Singleplayer", "Multiplayer", "Open World", "Story Rich").
public struct Tag: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the tag.
    public let id: Int

    /// Display name of the tag.
    public let name: String

    /// URL-friendly identifier for the tag.
    public let slug: String

    /// Language code of the tag.
    public let language: String?

    /// Total number of games with this tag.
    public let gamesCount: Int?

    /// Creates a new tag instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the tag.
    ///   - name: Display name of the tag.
    ///   - slug: URL-friendly identifier.
    ///   - language: Language code of the tag.
    ///   - gamesCount: Total number of games with this tag.
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
