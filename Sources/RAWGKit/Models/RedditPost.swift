//
// RedditPost.swift
// RAWGKit
//

import Foundation

/// Reddit post from game's subreddit
public struct RedditPost: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let text: String
    public let image: String?
    public let url: String
    public let username: String
    public let usernameUrl: String?
    public let created: String

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
