//
// Achievement.swift
// RAWGKit
//

import Foundation

/// Represents a game achievement from the RAWG API.
///
/// Achievements are in-game accomplishments that players can unlock.
public struct Achievement: Codable, Identifiable, Sendable {
    /// Unique identifier for the achievement.
    public let id: Int

    /// Display name of the achievement.
    public let name: String

    /// Description of how to unlock the achievement.
    public let description: String

    /// URL to the achievement icon image.
    public let image: String?

    /// Percentage of players who have unlocked this achievement.
    public let percent: String?

    /// Creates a new achievement instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the achievement.
    ///   - name: Display name of the achievement.
    ///   - description: Description of how to unlock it.
    ///   - image: URL to the achievement icon.
    ///   - percent: Percentage of players who unlocked it.
    public init(
        id: Int,
        name: String,
        description: String,
        image: String? = nil,
        percent: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.percent = percent
    }

    /// Achievement completion percentage as a double
    public var percentValue: Double? {
        guard let percent else { return nil }
        return Double(percent)
    }
}
