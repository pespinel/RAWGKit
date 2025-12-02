//
//  PlatformInfo.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

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
