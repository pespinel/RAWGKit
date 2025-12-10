//
//  Publisher.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a game publisher from the RAWG API.
///
/// Publishers are companies responsible for marketing, distributing, and funding games.
public struct Publisher: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the publisher.
    public let id: Int

    /// Company name.
    public let name: String

    /// URL-friendly identifier for the publisher.
    public let slug: String

    /// Total number of games published.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// Creates a new publisher instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the publisher.
    ///   - name: Company name.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games published.
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
