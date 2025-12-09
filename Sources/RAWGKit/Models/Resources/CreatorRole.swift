//
//  CreatorRole.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a creator's role or position in game development.
///
/// Defines the type of work a creator performed on a game
/// (e.g., "Director", "Designer", "Artist", "Composer", "Voice Actor").
public struct CreatorRole: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the role.
    public let id: Int

    /// Display name of the role.
    public let name: String

    /// URL-friendly identifier for the role.
    public let slug: String

    /// Creates a new creator role instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the role.
    ///   - name: Display name of the role.
    ///   - slug: URL-friendly identifier.
    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
