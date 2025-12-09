//
//  StoreDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed store information from the RAWG API.
///
/// Extends basic store information with an HTML-formatted description.
public struct StoreDetails: Codable, Identifiable, Sendable {
    /// Unique identifier for the store.
    public let id: Int

    /// Display name of the store.
    public let name: String

    /// URL-friendly identifier for the store.
    public let slug: String

    /// Web domain of the store.
    public let domain: String?

    /// Total number of games available on this store.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// HTML-formatted description of the store.
    public let description: String?

    /// Creates a new store details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the store.
    ///   - name: Display name of the store.
    ///   - slug: URL-friendly identifier.
    ///   - domain: Web domain of the store.
    ///   - gamesCount: Total number of games available.
    ///   - imageBackground: URL to a representative background image.
    ///   - description: HTML-formatted description.
    public init(
        id: Int,
        name: String,
        slug: String,
        domain: String? = nil,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.domain = domain
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain, description
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
