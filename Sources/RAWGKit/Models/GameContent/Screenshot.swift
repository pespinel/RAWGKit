//
//  Screenshot.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a full-resolution game screenshot from the RAWG API.
///
/// Screenshots provide high-quality images showcasing game visuals.
public struct Screenshot: Codable, Identifiable, Sendable {
    /// Unique identifier for the screenshot.
    public let id: Int

    /// URL to the full-resolution screenshot image.
    public let image: String

    /// Image width in pixels.
    public let width: Int?

    /// Image height in pixels.
    public let height: Int?

    /// Whether this screenshot has been deleted.
    public let isDeleted: Bool?

    /// Creates a new screenshot instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the screenshot.
    ///   - image: URL to the full-resolution image.
    ///   - width: Image width in pixels.
    ///   - height: Image height in pixels.
    ///   - isDeleted: Whether the screenshot has been deleted.
    public init(
        id: Int,
        image: String,
        width: Int? = nil,
        height: Int? = nil,
        isDeleted: Bool? = nil
    ) {
        self.id = id
        self.image = image
        self.width = width
        self.height = height
        self.isDeleted = isDeleted
    }

    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}
