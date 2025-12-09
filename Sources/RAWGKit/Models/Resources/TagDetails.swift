//
//  TagDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed tag information from the RAWG API.
///
/// Extends basic tag information with an HTML-formatted description.
public struct TagDetails: Codable, Identifiable, Sendable {
    /// Unique identifier for the tag.
    public let id: Int

    /// Display name of the tag.
    public let name: String

    /// URL-friendly identifier for the tag.
    public let slug: String

    /// Total number of games with this tag.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// HTML-formatted description of the tag.
    public let description: String?

    /// Language code of the tag.
    public let language: String?

    /// Creates a new tag details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the tag.
    ///   - name: Display name of the tag.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games with this tag.
    ///   - imageBackground: URL to a representative background image.
    ///   - description: HTML-formatted description.
    ///   - language: Language code of the tag.
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
