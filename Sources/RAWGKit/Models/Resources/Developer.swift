//
//  Developer.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a game development studio from the RAWG API.
///
/// Developers are companies or teams responsible for creating games.
public struct Developer: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the developer.
    public let id: Int

    /// Studio or company name.
    public let name: String

    /// URL-friendly identifier for the developer.
    public let slug: String

    /// Total number of games developed.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// Creates a new developer instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the developer.
    ///   - name: Studio or company name.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games developed.
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
