//
// RedditPost.swift
// RAWGKit
//

import Foundation

/// Represents a Reddit post from a game's subreddit from the RAWG API.
///
/// Contains information about community discussions related to the game.
public struct RedditPost: Codable, Identifiable, Sendable {
    /// Unique identifier for the post.
    public let id: Int

    /// Post title.
    public let name: String

    /// Post content/body.
    public let text: String

    /// URL to the post image (if any).
    public let image: String?

    /// URL to the Reddit post.
    public let url: String

    /// Username of the post author.
    public let username: String

    /// URL to the author's profile.
    public let usernameUrl: String?

    /// Post creation timestamp.
    public let created: String

    /// Creates a new Reddit post instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the post.
    ///   - name: Post title.
    ///   - text: Post content/body.
    ///   - image: URL to the post image.
    ///   - url: URL to the Reddit post.
    ///   - username: Username of the author.
    ///   - usernameUrl: URL to the author's profile.
    ///   - created: Post creation timestamp.
    public init(
        id: Int,
        name: String,
        text: String,
        image: String? = nil,
        url: String,
        username: String,
        usernameUrl: String? = nil,
        created: String
    ) {
        self.id = id
        self.name = name
        self.text = text
        self.image = image
        self.url = url
        self.username = username
        self.usernameUrl = usernameUrl
        self.created = created
    }

    enum CodingKeys: String, CodingKey {
        case id, name, text, image, url, username, created
        case usernameUrl = "username_url"
    }
}
