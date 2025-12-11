//
// Platform.swift
// RAWGKit
//

import Foundation

/// Represents a gaming platform from the RAWG API.
///
/// Platforms are systems on which games can be played
/// (e.g., PlayStation 5, Xbox Series X, PC, Nintendo Switch).
public struct Platform: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the platform.
    public let id: Int

    /// Display name of the platform.
    public let name: String

    /// URL-friendly identifier for the platform.
    public let slug: String

    /// Creates a new platform instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the platform.
    ///   - name: Display name of the platform.
    ///   - slug: URL-friendly identifier.
    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

// MARK: - Popular Platforms

public extension Platform {
    /// Popular gaming platforms for quick access.
    ///
    /// These constants represent the most commonly used platforms
    /// with their official RAWG API IDs.
    enum Popular {
        /// PC platform (id: 4)
        public static let pc = Platform(id: 4, name: "PC", slug: "pc")

        /// PlayStation 5 (id: 187)
        public static let playStation5 = Platform(id: 187, name: "PlayStation 5", slug: "playstation5")

        /// PlayStation 4 (id: 18)
        public static let playStation4 = Platform(id: 18, name: "PlayStation 4", slug: "playstation4")

        /// Xbox Series X/S (id: 186)
        public static let xboxSeriesXS = Platform(id: 186, name: "Xbox Series X/S", slug: "xbox-series-x")

        /// Xbox One (id: 1)
        public static let xboxOne = Platform(id: 1, name: "Xbox One", slug: "xbox-one")

        /// Nintendo Switch (id: 7)
        public static let nintendoSwitch = Platform(id: 7, name: "Nintendo Switch", slug: "nintendo-switch")

        /// iOS (id: 3)
        public static let iOS = Platform(id: 3, name: "iOS", slug: "ios")

        /// Android (id: 21)
        public static let android = Platform(id: 21, name: "Android", slug: "android")

        /// macOS (id: 5)
        public static let macOS = Platform(id: 5, name: "macOS", slug: "macos")

        /// Linux (id: 6)
        public static let linux = Platform(id: 6, name: "Linux", slug: "linux")

        /// Array of all popular platforms for iteration.
        public static let all: [Platform] = [
            pc,
            playStation5,
            playStation4,
            xboxSeriesXS,
            xboxOne,
            nintendoSwitch,
            iOS,
            android,
            macOS,
            linux,
        ]
    }
}
