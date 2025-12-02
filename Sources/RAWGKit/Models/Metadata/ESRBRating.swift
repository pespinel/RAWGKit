//
//  ESRBRating.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// ESRB Rating
public struct ESRBRating: Codable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
