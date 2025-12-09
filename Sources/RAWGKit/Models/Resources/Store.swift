//
// Store.swift
// RAWGKit
//

import Foundation

/// Represents a digital game store platform from the RAWG API.
///
/// Stores are platforms where games can be purchased or downloaded
/// (e.g., Steam, PlayStation Store, Xbox Store, Epic Games Store).
public struct Store: Codable, Identifiable, Hashable, Sendable {
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

    /// Creates a new store instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the store.
    ///   - name: Display name of the store.
    ///   - slug: URL-friendly identifier.
    ///   - domain: Web domain of the store.
    ///   - gamesCount: Total number of games available.
    ///   - imageBackground: URL to a representative background image.
    public init(
        id: Int,
        name: String,
        slug: String,
        domain: String? = nil,
        gamesCount: Int? = nil,
        imageBackground: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.domain = domain
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
