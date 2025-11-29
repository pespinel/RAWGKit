//
// RAWGResponse.swift
// RAWGKit
//

import Foundation

/// Generic response wrapper for paginated API responses
public struct RAWGResponse<T: Codable>: Codable, Sendable where T: Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [T]

    public var hasNextPage: Bool {
        next != nil
    }

    public var isEmpty: Bool {
        results.isEmpty
    }

    public init(
        count: Int,
        next: String? = nil,
        previous: String? = nil,
        results: [T]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

// MARK: - Type Aliases

public typealias GamesResponse = RAWGResponse<Game>
public typealias GenresResponse = RAWGResponse<Genre>
public typealias PlatformsResponse = RAWGResponse<Platform>
public typealias ParentPlatformsResponse = RAWGResponse<ParentPlatform>
public typealias DevelopersResponse = RAWGResponse<Developer>
public typealias PublishersResponse = RAWGResponse<Publisher>
public typealias StoresResponse = RAWGResponse<Store>
public typealias TagsResponse = RAWGResponse<Tag>
public typealias CreatorsResponse = RAWGResponse<Creator>
public typealias CreatorRolesResponse = RAWGResponse<CreatorRole>
public typealias GameStoresResponse = RAWGResponse<GameStore>
public typealias RedditPostsResponse = RAWGResponse<RedditPost>

// MARK: - Screenshots Response

public struct ScreenshotsResponse: Codable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Screenshot]

    public init(
        count: Int,
        next: String? = nil,
        previous: String? = nil,
        results: [Screenshot]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct Screenshot: Codable, Identifiable, Sendable {
    public let id: Int
    public let image: String
    public let width: Int?
    public let height: Int?
    public let isDeleted: Bool?

    public init(
        id: Int,
        image: String,
        width: Int? = nil,
        height: Int? = nil,
        isDeleted: Bool? = nil
    ) {
        self.id = id
        self.image = image
        self.width = width
        self.height = height
        self.isDeleted = isDeleted
    }

    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}
