//
// RAWGResponse.swift
// RAWGKit
//

import Foundation

/// Generic response wrapper for paginated API responses
public struct RAWGResponse<T: Codable>: Codable, Sendable where T: Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [T]

    public var hasNextPage: Bool {
        next != nil
    }

    public var isEmpty: Bool {
        results.isEmpty
    }

    public init(
        count: Int,
        next: String? = nil,
        previous: String? = nil,
        results: [T]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
