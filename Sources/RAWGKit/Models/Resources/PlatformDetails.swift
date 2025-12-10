//
//  PlatformDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed platform information from the RAWG API.
///
/// Extends basic platform information with description, images, and lifecycle dates.
public struct PlatformDetails: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the platform.
    public let id: Int

    /// Display name of the platform.
    public let name: String

    /// URL-friendly identifier for the platform.
    public let slug: String

    /// Total number of games available on this platform.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// HTML-formatted description of the platform.
    public let description: String?

    /// URL to the platform's logo or icon.
    public let image: String?

    /// Year the platform was released.
    public let yearStart: Int?

    /// Year the platform was discontinued (if applicable).
    public let yearEnd: Int?

    /// Creates a new platform details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the platform.
    ///   - name: Display name of the platform.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games available.
    ///   - imageBackground: URL to a representative background image.
    ///   - description: HTML-formatted description.
    ///   - image: URL to the platform's logo or icon.
    ///   - yearStart: Year the platform was released.
    ///   - yearEnd: Year the platform was discontinued.
    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil,
        description: String? = nil,
        image: String? = nil,
        yearStart: Int? = nil,
        yearEnd: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.description = description
        self.image = image
        self.yearStart = yearStart
        self.yearEnd = yearEnd
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, image
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case yearStart = "year_start"
        case yearEnd = "year_end"
    }
}
