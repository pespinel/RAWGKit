//
// Genre.swift
// RAWGKit
//

import Foundation

/// Represents a game genre from the RAWG API.
///
/// Genres categorize games by their gameplay style or theme
/// (e.g., Action, RPG, Strategy, Puzzle).
public struct Genre: Codable, Identifiable, Hashable, Sendable {
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

    /// Creates a new genre instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the genre.
    ///   - name: Display name of the genre.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games in this genre.
    ///   - imageBackground: URL to a representative background image.
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
