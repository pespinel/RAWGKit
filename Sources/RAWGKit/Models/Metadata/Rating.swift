//
//  Rating.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a rating category breakdown from the RAWG API.
///
/// Shows distribution of user ratings across different sentiment categories
/// (e.g., "exceptional", "recommended", "meh", "skip").
public struct Rating: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the rating category.
    public let id: Int

    /// Rating category title (e.g., "exceptional", "recommended").
    public let title: String

    /// Number of ratings in this category.
    public let count: Int

    /// Percentage of total ratings in this category (0-100).
    public let percent: Double

    /// Creates a new rating breakdown instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the category.
    ///   - title: Rating category title.
    ///   - count: Number of ratings in this category.
    ///   - percent: Percentage of total ratings (0-100).
    public init(id: Int, title: String, count: Int, percent: Double) {
        self.id = id
        self.title = title
        self.count = count
        self.percent = percent
    }
}
