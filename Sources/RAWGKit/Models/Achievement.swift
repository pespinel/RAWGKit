//
// Achievement.swift
// RAWGKit
//

import Foundation

/// Game achievement
public struct Achievement: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let description: String
    public let image: String?
    public let percent: String?

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
