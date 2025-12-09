//
// YouTubeVideo.swift
// RAWGKit
//

import Foundation

/// Represents a YouTube video related to a game from the RAWG API.
///
/// Contains comprehensive YouTube video metadata including engagement metrics.
public struct YouTubeVideo: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier in the RAWG database.
    public let id: Int

    /// YouTube video ID.
    public let externalId: String?

    /// YouTube channel ID.
    public let channelId: String?

    /// YouTube channel name.
    public let channelTitle: String?

    /// Video title.
    public let name: String?

    /// Video description.
    public let description: String?

    /// Video creation timestamp.
    public let created: String?

    /// Total view count.
    public let viewCount: Int?

    /// Total comments count.
    public let commentsCount: Int?

    /// Total likes count.
    public let likeCount: Int?

    /// Total dislikes count.
    public let dislikeCount: Int?

    /// Number of times favorited.
    public let favoriteCount: Int?

    /// Video thumbnails in different resolutions.
    public let thumbnails: YouTubeThumbnails?

    /// Creates a new YouTube video instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier in RAWG database.
    ///   - externalId: YouTube video ID.
    ///   - channelId: YouTube channel ID.
    ///   - channelTitle: YouTube channel name.
    ///   - name: Video title.
    ///   - description: Video description.
    ///   - created: Video creation timestamp.
    ///   - viewCount: Total view count.
    ///   - commentsCount: Total comments count.
    ///   - likeCount: Total likes count.
    ///   - dislikeCount: Total dislikes count.
    ///   - favoriteCount: Number of times favorited.
    ///   - thumbnails: Video thumbnails.
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

/// Contains YouTube video thumbnails in different resolutions.
public struct YouTubeThumbnails: Codable, Hashable, Sendable {
    /// Medium resolution thumbnail.
    public let medium: YouTubeThumbnail?

    /// High resolution thumbnail.
    public let high: YouTubeThumbnail?

    /// Maximum resolution thumbnail.
    public let maxres: YouTubeThumbnail?

    /// Creates a new thumbnails instance.
    ///
    /// - Parameters:
    ///   - medium: Medium resolution thumbnail.
    ///   - high: High resolution thumbnail.
    ///   - maxres: Maximum resolution thumbnail.
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

/// Represents a single YouTube thumbnail with dimensions.
public struct YouTubeThumbnail: Codable, Hashable, Sendable {
    /// URL to the thumbnail image.
    public let url: String?

    /// Thumbnail width in pixels.
    public let width: Int?

    /// Thumbnail height in pixels.
    public let height: Int?

    /// Creates a new thumbnail instance.
    ///
    /// - Parameters:
    ///   - url: URL to the thumbnail image.
    ///   - width: Thumbnail width in pixels.
    ///   - height: Thumbnail height in pixels.
    public init(url: String? = nil, width: Int? = nil, height: Int? = nil) {
        self.url = url
        self.width = width
        self.height = height
    }
}
