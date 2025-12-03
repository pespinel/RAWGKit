//
// TwitchStream.swift
// RAWGKit
//

import Foundation

/// Twitch stream information for a game
public struct TwitchStream: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let externalId: Int?
    public let name: String?
    public let description: String?
    public let created: String?
    public let published: String?
    public let thumbnail: String?
    public let viewCount: Int?
    public let language: String?

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
