//
//  PlatformInfo.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents platform-specific information for a game.
///
/// Contains the platform details along with the game's release date
/// and system requirements for that platform.
public struct PlatformInfo: Codable, Identifiable, Hashable, Sendable {
    /// The platform information.
    public let platform: Platform

    /// Release date on this platform in ISO 8601 format.
    public let releasedAt: String?

    /// System requirements for this platform.
    public let requirements: Requirements?

    /// Unique identifier derived from the platform.
    public var id: Int { platform.id }

    /// Creates a new platform info instance.
    ///
    /// - Parameters:
    ///   - platform: The platform information.
    ///   - releasedAt: Release date on this platform.
    ///   - requirements: System requirements for this platform.
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
