//
// ResourceDetailsModelsTests1.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Resource Details Models Tests - Part 1")
struct ResourceDetailsModelsTests1 {
    // MARK: - CreatorDetails Tests

    @Test("CreatorDetails initializes with all fields")
    func creatorDetailsInitialization() {
        let creator = CreatorDetails(
            id: 78,
            name: "Hideo Kojima",
            slug: "hideo-kojima",
            image: "https://example.com/kojima.jpg",
            imageBackground: "https://example.com/kojima_bg.jpg",
            description: "<p>Legendary game designer</p>",
            gamesCount: 30,
            reviewsCount: 150,
            rating: "4.5",
            ratingTop: 5,
            updated: "2024-01-15"
        )

        #expect(creator.id == 78)
        #expect(creator.name == "Hideo Kojima")
        #expect(creator.slug == "hideo-kojima")
        #expect(creator.image == "https://example.com/kojima.jpg")
        #expect(creator.imageBackground == "https://example.com/kojima_bg.jpg")
        #expect(creator.description == "<p>Legendary game designer</p>")
        #expect(creator.gamesCount == 30)
        #expect(creator.reviewsCount == 150)
        #expect(creator.rating == "4.5")
        #expect(creator.ratingTop == 5)
        #expect(creator.updated == "2024-01-15")
    }

    @Test("CreatorDetails initializes with minimal fields")
    func creatorDetailsMinimalInitialization() {
        let creator = CreatorDetails(
            id: 1,
            name: "John Doe",
            slug: "john-doe"
        )

        #expect(creator.id == 1)
        #expect(creator.name == "John Doe")
        #expect(creator.slug == "john-doe")
        #expect(creator.image == nil)
        #expect(creator.imageBackground == nil)
        #expect(creator.description == nil)
        #expect(creator.gamesCount == nil)
        #expect(creator.reviewsCount == nil)
        #expect(creator.rating == nil)
        #expect(creator.ratingTop == nil)
        #expect(creator.updated == nil)
    }

    @Test("CreatorDetails decodes from JSON")
    func creatorDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 78,
            "name": "Hideo Kojima",
            "slug": "hideo-kojima",
            "image": "https://example.com/kojima.jpg",
            "image_background": "https://example.com/kojima_bg.jpg",
            "description": "<p>Legendary game designer</p>",
            "games_count": 30,
            "reviews_count": 150,
            "rating": "4.5",
            "rating_top": 5,
            "updated": "2024-01-15"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let creator = try decoder.decode(CreatorDetails.self, from: json)

        #expect(creator.id == 78)
        #expect(creator.name == "Hideo Kojima")
        #expect(creator.gamesCount == 30)
        #expect(creator.reviewsCount == 150)
    }

    @Test("CreatorDetails handles zero games count")
    func creatorDetailsZeroGamesCount() {
        let creator = CreatorDetails(
            id: 1,
            name: "New Creator",
            slug: "new-creator",
            gamesCount: 0
        )

        #expect(creator.gamesCount == 0)
    }

    // MARK: - DeveloperDetails Tests

    @Test("DeveloperDetails initializes with all fields")
    func developerDetailsInitialization() {
        let developer = DeveloperDetails(
            id: 3454,
            name: "Rockstar Games",
            slug: "rockstar-games",
            gamesCount: 25,
            imageBackground: "https://example.com/rockstar_bg.jpg",
            description: "<p>Famous game developer</p>"
        )

        #expect(developer.id == 3454)
        #expect(developer.name == "Rockstar Games")
        #expect(developer.slug == "rockstar-games")
        #expect(developer.gamesCount == 25)
        #expect(developer.imageBackground == "https://example.com/rockstar_bg.jpg")
        #expect(developer.description == "<p>Famous game developer</p>")
    }

    @Test("DeveloperDetails initializes with minimal fields")
    func developerDetailsMinimalInitialization() {
        let developer = DeveloperDetails(
            id: 1,
            name: "Indie Studio",
            slug: "indie-studio"
        )

        #expect(developer.id == 1)
        #expect(developer.name == "Indie Studio")
        #expect(developer.slug == "indie-studio")
        #expect(developer.gamesCount == nil)
        #expect(developer.imageBackground == nil)
        #expect(developer.description == nil)
    }

    @Test("DeveloperDetails decodes from JSON")
    func developerDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 3454,
            "name": "Rockstar Games",
            "slug": "rockstar-games",
            "games_count": 25,
            "image_background": "https://example.com/rockstar_bg.jpg",
            "description": "<p>Famous game developer</p>"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let developer = try decoder.decode(DeveloperDetails.self, from: json)

        #expect(developer.id == 3454)
        #expect(developer.name == "Rockstar Games")
        #expect(developer.gamesCount == 25)
    }

    @Test("DeveloperDetails handles very large games count")
    func developerDetailsLargeGamesCount() {
        let developer = DeveloperDetails(
            id: 1,
            name: "Big Studio",
            slug: "big-studio",
            gamesCount: 999_999
        )

        #expect(developer.gamesCount == 999_999)
    }

    // MARK: - PublisherDetails Tests

    @Test("PublisherDetails initializes with all fields")
    func publisherDetailsInitialization() {
        let publisher = PublisherDetails(
            id: 354,
            name: "Electronic Arts",
            slug: "electronic-arts",
            gamesCount: 500,
            imageBackground: "https://example.com/ea_bg.jpg",
            description: "<p>Major video game publisher</p>"
        )

        #expect(publisher.id == 354)
        #expect(publisher.name == "Electronic Arts")
        #expect(publisher.slug == "electronic-arts")
        #expect(publisher.gamesCount == 500)
        #expect(publisher.imageBackground == "https://example.com/ea_bg.jpg")
        #expect(publisher.description == "<p>Major video game publisher</p>")
    }

    @Test("PublisherDetails initializes with minimal fields")
    func publisherDetailsMinimalInitialization() {
        let publisher = PublisherDetails(
            id: 1,
            name: "Small Publisher",
            slug: "small-publisher"
        )

        #expect(publisher.id == 1)
        #expect(publisher.name == "Small Publisher")
        #expect(publisher.slug == "small-publisher")
        #expect(publisher.gamesCount == nil)
        #expect(publisher.imageBackground == nil)
        #expect(publisher.description == nil)
    }

    @Test("PublisherDetails decodes from JSON")
    func publisherDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 354,
            "name": "Electronic Arts",
            "slug": "electronic-arts",
            "games_count": 500,
            "image_background": "https://example.com/ea_bg.jpg",
            "description": "<p>Major video game publisher</p>"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let publisher = try decoder.decode(PublisherDetails.self, from: json)

        #expect(publisher.id == 354)
        #expect(publisher.name == "Electronic Arts")
        #expect(publisher.gamesCount == 500)
    }

    @Test("PublisherDetails handles empty description")
    func publisherDetailsEmptyDescription() throws {
        let json = Data("""
        {
            "id": 1,
            "name": "Publisher",
            "slug": "publisher",
            "description": ""
        }
        """.utf8)

        let decoder = JSONDecoder()
        let publisher = try decoder.decode(PublisherDetails.self, from: json)

        #expect(publisher.description?.isEmpty == true)
    }
}
