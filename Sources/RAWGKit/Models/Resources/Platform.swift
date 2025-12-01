//
// Platform.swift
// RAWGKit
//

import Foundation

/// Platform information
public struct Platform: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
