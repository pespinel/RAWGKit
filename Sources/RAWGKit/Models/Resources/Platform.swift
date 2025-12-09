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
