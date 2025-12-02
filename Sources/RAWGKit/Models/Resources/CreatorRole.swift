//
//  CreatorRole.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Creator position/role
public struct CreatorRole: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
