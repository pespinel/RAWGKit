//
//  Requirements.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents system requirements for running a game on a specific platform.
///
/// Typically includes hardware and software specifications for PC platforms.
public struct Requirements: Codable, Hashable, Sendable {
    /// Minimum system requirements to run the game.
    public let minimum: String?

    /// Recommended system requirements for optimal performance.
    public let recommended: String?

    /// Creates a new requirements instance.
    ///
    /// - Parameters:
    ///   - minimum: Minimum system requirements.
    ///   - recommended: Recommended system requirements.
    public init(minimum: String? = nil, recommended: String? = nil) {
        self.minimum = minimum
        self.recommended = recommended
    }
}
