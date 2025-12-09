//
//  PublisherDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed publisher information from the RAWG API.
///
/// Extends basic publisher information with an HTML-formatted description.
public struct PublisherDetails: Codable, Identifiable, Sendable {
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

    /// HTML-formatted description of the publisher.
    public let description: String?

    /// Creates a new publisher details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the publisher.
    ///   - name: Company name.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games published.
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
