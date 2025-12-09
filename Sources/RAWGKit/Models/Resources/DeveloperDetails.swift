//
//  DeveloperDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed developer information from the RAWG API.
///
/// Extends basic developer information with an HTML-formatted description.
public struct DeveloperDetails: Codable, Identifiable, Sendable {
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

    /// HTML-formatted description of the developer.
    public let description: String?

    /// Creates a new developer details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the developer.
    ///   - name: Studio or company name.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games developed.
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
