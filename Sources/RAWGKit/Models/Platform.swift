//
// Platform.swift
// RAWGKit
//

import Foundation

/// Platform information
public struct Platform: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

/// Platform info with release date and requirements
public struct PlatformInfo: Codable, Identifiable, Hashable, Sendable {
    public let platform: Platform
    public let releasedAt: String?
    public let requirements: Requirements?

    public var id: Int { platform.id }

    public init(
        platform: Platform,
        releasedAt: String? = nil,
        requirements: Requirements? = nil
    ) {
        self.platform = platform
        self.releasedAt = releasedAt
        self.requirements = requirements
    }

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

/// System requirements for a platform
public struct Requirements: Codable, Hashable, Sendable {
    public let minimum: String?
    public let recommended: String?

    public init(minimum: String? = nil, recommended: String? = nil) {
        self.minimum = minimum
        self.recommended = recommended
    }
}
