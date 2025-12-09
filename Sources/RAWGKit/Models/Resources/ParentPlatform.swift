//
//  ParentPlatform.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a platform family grouping from the RAWG API.
///
/// Parent platforms group related platforms into families
/// (e.g., "PlayStation" includes PS4, PS5; "Xbox" includes Xbox One, Series X|S).
public struct ParentPlatform: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the parent platform.
    public let id: Int

    /// Display name of the platform family.
    public let name: String

    /// URL-friendly identifier for the parent platform.
    public let slug: String

    /// List of child platforms in this family.
    public let platforms: [Platform]?

    /// Creates a new parent platform instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the parent platform.
    ///   - name: Display name of the platform family.
    ///   - slug: URL-friendly identifier.
    ///   - platforms: List of child platforms in this family.
    public init(
        id: Int,
        name: String,
        slug: String,
        platforms: [Platform]? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.platforms = platforms
    }
}
