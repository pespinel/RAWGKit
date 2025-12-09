//
//  CreatorDetails.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents detailed creator information from the RAWG API.
///
/// Extends basic creator information with description, ratings, and review counts.
public struct CreatorDetails: Codable, Identifiable, Sendable {
    /// Unique identifier for the creator.
    public let id: Int

    /// Full name of the creator.
    public let name: String

    /// URL-friendly identifier for the creator.
    public let slug: String

    /// URL to the creator's profile image.
    public let image: String?

    /// URL to a representative background image.
    public let imageBackground: String?

    /// HTML-formatted description of the creator's work and career.
    public let description: String?

    /// Total number of games the creator worked on.
    public let gamesCount: Int?

    /// Total number of reviews about the creator's work.
    public let reviewsCount: Int?

    /// Average rating as a string.
    public let rating: String?

    /// Maximum rating category.
    public let ratingTop: Int?

    /// Last update timestamp.
    public let updated: String?

    /// Creates a new creator details instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the creator.
    ///   - name: Full name of the creator.
    ///   - slug: URL-friendly identifier.
    ///   - image: URL to the creator's profile image.
    ///   - imageBackground: URL to a representative background image.
    ///   - description: HTML-formatted description.
    ///   - gamesCount: Total number of games worked on.
    ///   - reviewsCount: Total number of reviews.
    ///   - rating: Average rating as a string.
    ///   - ratingTop: Maximum rating category.
    ///   - updated: Last update timestamp.
    public init(
        id: Int,
        name: String,
        slug: String,
        image: String? = nil,
        imageBackground: String? = nil,
        description: String? = nil,
        gamesCount: Int? = nil,
        reviewsCount: Int? = nil,
        rating: String? = nil,
        ratingTop: Int? = nil,
        updated: String? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.image = image
        self.imageBackground = imageBackground
        self.description = description
        self.gamesCount = gamesCount
        self.reviewsCount = reviewsCount
        self.rating = rating
        self.ratingTop = ratingTop
        self.updated = updated
    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image, description, rating, updated
        case imageBackground = "image_background"
        case gamesCount = "games_count"
        case reviewsCount = "reviews_count"
        case ratingTop = "rating_top"
    }
}
