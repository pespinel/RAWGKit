//
//  GenreDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed genre information from the RAWG API.
///
/// Extends basic genre information with an HTML-formatted description.
public struct GenreDetails: Codable, Identifiable, Sendable {
    /// Unique identifier for the genre.
    public let id: Int

    /// Display name of the genre.
    public let name: String

    /// URL-friendly identifier for the genre.
    public let slug: String

    /// Total number of games in this genre.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// HTML-formatted description of the genre.
    public let description: String?

    /// Creates a new genre details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the genre.
    ///   - name: Display name of the genre.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games in this genre.
    ///   - imageBackground: URL to a representative background image.
    ///   - description: HTML-formatted description.
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
