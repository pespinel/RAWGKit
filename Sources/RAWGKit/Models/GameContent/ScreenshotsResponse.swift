//
//  ScreenshotsResponse.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//


public struct ScreenshotsResponse: Codable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Screenshot]

    public init(
        count: Int,
        next: String? = nil,
        previous: String? = nil,
        results: [Screenshot]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}