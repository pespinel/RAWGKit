//
// RAWGResponse.swift
// RAWGKit
//

import Foundation

/// Generic response wrapper for paginated API responses from RAWG.
///
/// This structure wraps all paginated responses from the RAWG API,
/// providing metadata about pagination and the actual results.
///
/// - Note: The generic type `T` must conform to both `Codable` and `Sendable`.
public struct RAWGResponse<T: Codable>: Codable, Sendable where T: Sendable {
    /// Total number of items across all pages.
    public let count: Int

    /// URL to the next page of results, if available.
    public let next: String?

    /// URL to the previous page of results, if available.
    public let previous: String?

    /// Array of results for the current page.
    public let results: [T]

    /// Whether there are more results available on the next page.
    public var hasNextPage: Bool {
        next != nil
    }

    /// Whether the results array is empty.
    public var isEmpty: Bool {
        results.isEmpty
    }

    /// Creates a new paginated response.
    ///
    /// - Parameters:
    ///   - count: Total number of items across all pages.
    ///   - next: URL to the next page of results.
    ///   - previous: URL to the previous page of results.
    ///   - results: Array of results for the current page.
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
