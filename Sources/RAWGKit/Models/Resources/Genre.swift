//
// Genre.swift
// RAWGKit
//

import Foundation

/// Represents a game genre from the RAWG API.
///
/// Genres categorize games by their gameplay style or theme
/// (e.g., Action, RPG, Strategy, Puzzle).
public struct Genre: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the genre.
    public let id: Int

    /// Display name of the genre.
    public let name: String

    /// URL-friendly identifier for the genre.
    public let slug: String

    /// Total number of games in this genre.
    public let gamesCount: Int?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// Creates a new genre instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the genre.
    ///   - name: Display name of the genre.
    ///   - slug: URL-friendly identifier.
    ///   - gamesCount: Total number of games in this genre.
    ///   - imageBackground: URL to a representative background image.
    public init(
        id: Int,
        name: String,
        slug: String,
        gamesCount: Int? = nil,
        imageBackground: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Popular Genres

public extension Genre {
    /// Popular game genres for quick access.
    ///
    /// These constants represent the most commonly used genres
    /// with their official RAWG API IDs.
    enum Popular {
        /// Action games (id: 4)
        public static let action = Genre(id: 4, name: "Action", slug: "action")

        /// Adventure games (id: 3)
        public static let adventure = Genre(id: 3, name: "Adventure", slug: "adventure")

        /// Role-Playing Games (id: 5)
        public static let rpg = Genre(id: 5, name: "RPG", slug: "role-playing-games-rpg")

        /// Shooter games (id: 2)
        public static let shooter = Genre(id: 2, name: "Shooter", slug: "shooter")

        /// Strategy games (id: 10)
        public static let strategy = Genre(id: 10, name: "Strategy", slug: "strategy")

        /// Simulation games (id: 14)
        public static let simulation = Genre(id: 14, name: "Simulation", slug: "simulation")

        /// Puzzle games (id: 7)
        public static let puzzle = Genre(id: 7, name: "Puzzle", slug: "puzzle")

        /// Sports games (id: 15)
        public static let sports = Genre(id: 15, name: "Sports", slug: "sports")

        /// Racing games (id: 1)
        public static let racing = Genre(id: 1, name: "Racing", slug: "racing")

        /// Fighting games (id: 6)
        public static let fighting = Genre(id: 6, name: "Fighting", slug: "fighting")

        /// Platformer games (id: 83)
        public static let platformer = Genre(id: 83, name: "Platformer", slug: "platformer")

        /// Indie games (id: 51)
        public static let indie = Genre(id: 51, name: "Indie", slug: "indie")

        /// Massively Multiplayer games (id: 59)
        public static let massivelyMultiplayer = Genre(
            id: 59,
            name: "Massively Multiplayer",
            slug: "massively-multiplayer"
        )

        /// Array of all popular genres for iteration.
        public static let all: [Genre] = [
            action,
            adventure,
            rpg,
            shooter,
            strategy,
            simulation,
            puzzle,
            sports,
            racing,
            fighting,
            platformer,
            indie,
            massivelyMultiplayer,
        ]
    }
}
