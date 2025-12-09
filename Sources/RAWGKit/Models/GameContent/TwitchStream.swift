//
// TwitchStream.swift
// RAWGKit
//

import Foundation

/// Represents a Twitch stream related to a game from the RAWG API.
///
/// Contains metadata about Twitch broadcasts featuring the game.
public struct TwitchStream: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier in the RAWG database.
    public let id: Int

    /// Twitch stream ID.
    public let externalId: Int?

    /// Stream title.
    public let name: String?

    /// Stream description.
    public let description: String?

    /// Stream creation timestamp.
    public let created: String?

    /// Stream publication timestamp.
    public let published: String?

    /// URL to the stream thumbnail.
    public let thumbnail: String?

    /// Total view count.
    public let viewCount: Int?

    /// Stream language code.
    public let language: String?

    /// Creates a new Twitch stream instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier in RAWG database.
    ///   - externalId: Twitch stream ID.
    ///   - name: Stream title.
    ///   - description: Stream description.
    ///   - created: Stream creation timestamp.
    ///   - published: Stream publication timestamp.
    ///   - thumbnail: URL to the stream thumbnail.
    ///   - viewCount: Total view count.
    ///   - language: Stream language code.
    public init(
        id: Int,
        externalId: Int? = nil,
        name: String? = nil,
        description: String? = nil,
        created: String? = nil,
        published: String? = nil,
        thumbnail: String? = nil,
        viewCount: Int? = nil,
        language: String? = nil
    ) {
        self.id = id
        self.externalId = externalId
        self.name = name
        self.description = description
        self.created = created
        self.published = published
        self.thumbnail = thumbnail
        self.viewCount = viewCount
        self.language = language
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description, created, published, thumbnail, language
        case externalId = "external_id"
        case viewCount = "view_count"
    }
}
