//
//  ShortScreenshot.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Screenshot thumbnail
public struct ShortScreenshot: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let image: String

    public init(id: Int, image: String) {
        self.id = id
        self.image = image
    }
}
