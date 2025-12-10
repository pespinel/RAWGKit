//
//  ScreenshotsResponse.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Response wrapper for paginated screenshot results.
///
/// Follows the standard RAWG pagination pattern for screenshot collections.
public struct ScreenshotsResponse: Codable, Hashable, Sendable {
    /// Total number of screenshots across all pages.
    public let count: Int

    /// URL to the next page of results.
    public let next: String?

    /// URL to the previous page of results.
    public let previous: String?

    /// Array of screenshots for the current page.
    public let results: [Screenshot]

    /// Creates a new screenshots response instance.
    ///
    /// - Parameters:
    ///   - count: Total number of screenshots.
    ///   - next: URL to the next page.
    ///   - previous: URL to the previous page.
    ///   - results: Array of screenshots.
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
