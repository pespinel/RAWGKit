//
//  Rating.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Rating breakdown
public struct Rating: Codable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let count: Int
    public let percent: Double

    public init(id: Int, title: String, count: Int, percent: Double) {
        self.id = id
        self.title = title
        self.count = count
        self.percent = percent
    }
}
