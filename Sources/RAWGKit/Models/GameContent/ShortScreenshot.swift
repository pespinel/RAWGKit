//
//  ShortScreenshot.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a screenshot thumbnail from the RAWG API.
///
/// Short screenshots are smaller preview images used in game listings.
public struct ShortScreenshot: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the screenshot.
    public let id: Int

    /// URL to the thumbnail image.
    public let image: String

    /// Creates a new short screenshot instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the screenshot.
    ///   - image: URL to the thumbnail image.
    public init(id: Int, image: String) {
        self.id = id
        self.image = image
    }
}
