//
// Creator.swift
// RAWGKit
//

import Foundation

/// Represents an individual game creator from the RAWG API.
///
/// Creators are people involved in game development, such as designers,
/// directors, artists, composers, or voice actors.
public struct Creator: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the creator.
    public let id: Int

    /// Full name of the creator.
    public let name: String

    /// URL-friendly identifier for the creator.
    public let slug: String

    /// URL to the creator's profile image.
    public let image: String?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// Total number of games the creator worked on.
    public let gamesCount: Int?

    /// Creates a new creator instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the creator.
    ///   - name: Full name of the creator.
    ///   - slug: URL-friendly identifier.
    ///   - image: URL to the creator's profile image.
    ///   - imageBackground: URL to a representative background image.
    ///   - gamesCount: Total number of games worked on.
    public init(
        id: Int,
        name: String,
        slug: String,
        image: String? = nil,
        imageBackground: String? = nil,
        gamesCount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.image = image
        self.imageBackground = imageBackground
        self.gamesCount = gamesCount
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case imageBackground = "image_background"
        case gamesCount = "games_count"
    }
}
