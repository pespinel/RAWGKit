//
//  ESRBRating.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents an ESRB (Entertainment Software Rating Board) age rating.
///
/// ESRB ratings indicate appropriate age groups for game content (E, T, M, etc.).
public struct ESRBRating: Codable, Hashable, Sendable {
    /// Unique identifier for the rating.
    public let id: Int

    /// Human-readable rating name (e.g., "Everyone", "Teen", "Mature").
    public let name: String

    /// URL-friendly identifier for the rating.
    public let slug: String

    /// Creates a new ESRB rating instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the rating.
    ///   - name: Human-readable rating name.
    ///   - slug: URL-friendly identifier.
    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
