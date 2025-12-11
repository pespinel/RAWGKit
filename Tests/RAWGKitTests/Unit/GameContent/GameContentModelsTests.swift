//
// GameContentModelsTests.swift
// RAWGKitTests
//
// Created by RAWGKit Tests on 11/12/2025.
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("GameContent Models Tests")
struct GameContentModelsTests {
    // MARK: - Achievement Tests

    @Test("Achievement initializes correctly")
    func achievementInitialization() {
        let achievement = Achievement(
            id: 1,
            name: "First Blood",
            description: "Get your first kill",
            image: "https://example.com/icon.png",
            percent: "75.5"
        )

        #expect(achievement.id == 1)
        #expect(achievement.name == "First Blood")
        #expect(achievement.description == "Get your first kill")
        #expect(achievement.image == "https://example.com/icon.png")
        #expect(achievement.percent == "75.5")
    }

    @Test("Achievement percentValue converts string to double")
    func achievementPercentValue() {
        let achievement1 = Achievement(
            id: 1,
            name: "Test",
            description: "Test",
            percent: "75.5"
        )
        #expect(achievement1.percentValue == 75.5)

        let achievement2 = Achievement(
            id: 2,
            name: "Test",
            description: "Test",
            percent: "100"
        )
        #expect(achievement2.percentValue == 100.0)

        let achievement3 = Achievement(
            id: 3,
            name: "Test",
            description: "Test",
            percent: nil
        )
        #expect(achievement3.percentValue == nil)

        let achievement4 = Achievement(
            id: 4,
            name: "Test",
            description: "Test",
            percent: "invalid"
        )
        #expect(achievement4.percentValue == nil)
    }

    @Test("Achievement conforms to Hashable")
    func achievementHashable() {
        let achievement1 = Achievement(
            id: 1,
            name: "Test",
            description: "Test"
        )
        let achievement2 = Achievement(
            id: 1,
            name: "Test",
            description: "Test"
        )
        let achievement3 = Achievement(
            id: 2,
            name: "Other",
            description: "Other"
        )

        #expect(achievement1 == achievement2)
        #expect(achievement1 != achievement3)

        var set = Set<Achievement>()
        set.insert(achievement1)
        #expect(set.contains(achievement2))
        #expect(!set.contains(achievement3))
    }

    // MARK: - Screenshot Tests

    @Test("Screenshot initializes correctly")
    func screenshotInitialization() {
        let screenshot = Screenshot(
            id: 1,
            image: "https://example.com/screenshot.jpg",
            width: 1920,
            height: 1080,
            isDeleted: false
        )

        #expect(screenshot.id == 1)
        #expect(screenshot.image == "https://example.com/screenshot.jpg")
        #expect(screenshot.width == 1920)
        #expect(screenshot.height == 1080)
        #expect(screenshot.isDeleted == false)
    }

    @Test("ShortScreenshot initializes correctly")
    func shortScreenshotInitialization() {
        let screenshot = ShortScreenshot(
            id: 1,
            image: "https://example.com/thumb.jpg"
        )

        #expect(screenshot.id == 1)
        #expect(screenshot.image == "https://example.com/thumb.jpg")
    }

    // MARK: - Movie Tests

    @Test("Movie initializes correctly")
    func movieInitialization() {
        let movieData = MovieData(
            size480: "https://example.com/video-480.mp4",
            max: "https://example.com/video-max.mp4"
        )

        let movie = Movie(
            id: 1,
            name: "Gameplay Trailer",
            preview: "https://example.com/preview.jpg",
            data: movieData
        )

        #expect(movie.id == 1)
        #expect(movie.name == "Gameplay Trailer")
        #expect(movie.preview == "https://example.com/preview.jpg")
        #expect(movie.data?.max == "https://example.com/video-max.mp4")
    }

    @Test("MovieData initializes correctly")
    func movieDataInitialization() {
        let movieData = MovieData(
            size480: "https://example.com/480.mp4",
            max: "https://example.com/max.mp4"
        )

        #expect(movieData.max == "https://example.com/max.mp4")
        #expect(movieData.size480 == "https://example.com/480.mp4")
    }

    // MARK: - GameStore Tests

    @Test("GameStore initializes correctly")
    func gameStoreInitialization() {
        let store = Store(
            id: 1,
            name: "Steam",
            slug: "steam",
            domain: "store.steampowered.com",
            gamesCount: 50000,
            imageBackground: "https://example.com/bg.jpg"
        )

        let gameStore = GameStore(
            id: 1,
            gameId: 3328,
            storeId: 1,
            url: "https://store.steampowered.com/app/12345",
            store: store
        )

        #expect(gameStore.id == 1)
        #expect(gameStore.url == "https://store.steampowered.com/app/12345")
        #expect(gameStore.store?.name == "Steam")
        #expect(gameStore.store?.domain == "store.steampowered.com")
    }

    // MARK: - YouTubeVideo Tests

    @Test("YouTubeVideo initializes correctly")
    func youTubeVideoInitialization() {
        let video = YouTubeVideo(
            id: 123,
            externalId: "dQw4w9WgXcQ",
            channelId: "UCchannel123",
            channelTitle: "Game Publisher",
            name: "Game Trailer",
            description: "Official trailer",
            created: "2023-01-01T00:00:00",
            viewCount: 1_000_000,
            commentsCount: 5000,
            likeCount: 50000,
            dislikeCount: 100,
            favoriteCount: 1000,
            thumbnails: nil
        )

        #expect(video.id == 123)
        #expect(video.externalId == "dQw4w9WgXcQ")
        #expect(video.name == "Game Trailer")
        #expect(video.viewCount == 1_000_000)
        #expect(video.channelTitle == "Game Publisher")
    }

    // MARK: - TwitchStream Tests

    @Test("TwitchStream initializes correctly")
    func twitchStreamInitialization() {
        let stream = TwitchStream(
            id: 123,
            externalId: 456,
            name: "Amazing Gameplay Stream",
            description: "Playing the new DLC",
            created: "2023-01-01T00:00:00",
            published: "2023-01-01T01:00:00",
            thumbnail: "https://example.com/thumb.jpg",
            viewCount: 500,
            language: "en"
        )

        #expect(stream.id == 123)
        #expect(stream.name == "Amazing Gameplay Stream")
        #expect(stream.viewCount == 500)
        #expect(stream.language == "en")
    }

    // MARK: - ScreenshotsResponse Tests

    @Test("ScreenshotsResponse initializes correctly")
    func screenshotsResponseInitialization() {
        let response = ScreenshotsResponse(
            count: 25,
            next: "https://api.rawg.io/api/games/3328/screenshots?page=2",
            previous: nil,
            results: []
        )

        #expect(response.count == 25)
        #expect(response.next == "https://api.rawg.io/api/games/3328/screenshots?page=2")
        #expect(response.previous == nil)
        #expect(response.results.isEmpty)
    }

    // MARK: - Codable Tests

    @Test("Achievement decodes from JSON")
    func achievementDecodesFromJSON() throws {
        let json = """
        {
            "id": 1,
            "name": "First Kill",
            "description": "Get your first kill",
            "image": "https://example.com/icon.png",
            "percent": "85.5"
        }
        """

        let data = json.data(using: .utf8)!
        let achievement = try JSONDecoder().decode(Achievement.self, from: data)

        #expect(achievement.id == 1)
        #expect(achievement.name == "First Kill")
        #expect(achievement.percentValue == 85.5)
    }

    @Test("Screenshot decodes from JSON")
    func screenshotDecodesFromJSON() throws {
        let json = """
        {
            "id": 1,
            "image": "https://example.com/screenshot.jpg",
            "width": 1920,
            "height": 1080,
            "is_deleted": false
        }
        """

        let data = json.data(using: .utf8)!
        let screenshot = try JSONDecoder().decode(Screenshot.self, from: data)

        #expect(screenshot.id == 1)
        #expect(screenshot.width == 1920)
        #expect(screenshot.height == 1080)
    }

    @Test("GameStore decodes from JSON")
    func gameStoreDecodesFromJSON() throws {
        let json = """
        {
            "id": 1,
            "url": "https://store.steampowered.com/app/12345",
            "store": {
                "id": 1,
                "name": "Steam",
                "slug": "steam",
                "domain": "store.steampowered.com",
                "games_count": 50000,
                "image_background": "https://example.com/bg.jpg"
            }
        }
        """

        let data = json.data(using: .utf8)!
        let gameStore = try JSONDecoder().decode(GameStore.self, from: data)

        #expect(gameStore.id == 1)
        #expect(gameStore.store?.name == "Steam")
        #expect(gameStore.store?.gamesCount == 50000)
    }
}
