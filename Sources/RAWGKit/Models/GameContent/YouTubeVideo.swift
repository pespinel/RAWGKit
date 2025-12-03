//
// YouTubeVideo.swift
// RAWGKit
//

import Foundation

/// YouTube video information for a game
public struct YouTubeVideo: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let externalId: String?
    public let channelId: String?
    public let channelTitle: String?
    public let name: String?
    public let description: String?
    public let created: String?
    public let viewCount: Int?
    public let commentsCount: Int?
    public let likeCount: Int?
    public let dislikeCount: Int?
    public let favoriteCount: Int?
    public let thumbnails: YouTubeThumbnails?

    public init(
        id: Int,
        externalId: String? = nil,
        channelId: String? = nil,
        channelTitle: String? = nil,
        name: String? = nil,
        description: String? = nil,
        created: String? = nil,
        viewCount: Int? = nil,
        commentsCount: Int? = nil,
        likeCount: Int? = nil,
        dislikeCount: Int? = nil,
        favoriteCount: Int? = nil,
        thumbnails: YouTubeThumbnails? = nil
    ) {
        self.id = id
        self.externalId = externalId
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.name = name
        self.description = description
        self.created = created
        self.viewCount = viewCount
        self.commentsCount = commentsCount
        self.likeCount = likeCount
        self.dislikeCount = dislikeCount
        self.favoriteCount = favoriteCount
        self.thumbnails = thumbnails
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description, created, thumbnails
        case externalId = "external_id"
        case channelId = "channel_id"
        case channelTitle = "channel_title"
        case viewCount = "view_count"
        case commentsCount = "comments_count"
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case favoriteCount = "favorite_count"
    }
}

/// YouTube video thumbnails
public struct YouTubeThumbnails: Codable, Hashable, Sendable {
    public let medium: YouTubeThumbnail?
    public let high: YouTubeThumbnail?
    public let maxres: YouTubeThumbnail?

    public init(
        medium: YouTubeThumbnail? = nil,
        high: YouTubeThumbnail? = nil,
        maxres: YouTubeThumbnail? = nil
    ) {
        self.medium = medium
        self.high = high
        self.maxres = maxres
    }
}

/// Single YouTube thumbnail
public struct YouTubeThumbnail: Codable, Hashable, Sendable {
    public let url: String?
    public let width: Int?
    public let height: Int?

    public init(url: String? = nil, width: Int? = nil, height: Int? = nil) {
        self.url = url
        self.width = width
        self.height = height
    }
}
