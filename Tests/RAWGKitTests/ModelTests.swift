//
// ModelTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Model Tests")
struct ModelTests {
    @Test("Genre decodes from JSON")
    func genreDecoding() throws {
        let json = Data("""
        {
            "id": 4,
            "name": "Action",
            "slug": "action",
            "games_count": 12345,
            "image_background": "https://example.com/action.jpg"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let genre = try decoder.decode(Genre.self, from: json)

        #expect(genre.id == 4)
        #expect(genre.name == "Action")
        #expect(genre.slug == "action")
        #expect(genre.gamesCount == 12345)
    }

    @Test("Platform decodes from JSON")
    func platformDecoding() throws {
        let json = Data("""
        {
            "id": 4,
            "name": "PC",
            "slug": "pc"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let platform = try decoder.decode(Platform.self, from: json)

        #expect(platform.id == 4)
        #expect(platform.name == "PC")
        #expect(platform.slug == "pc")
    }

    @Test("PlatformInfo decodes from JSON with requirements")
    func platformInfoDecoding() throws {
        let json = Data("""
        {
            "platform": {
                "id": 4,
                "name": "PC",
                "slug": "pc"
            },
            "released_at": "2020-12-10",
            "requirements": {
                "minimum": "Minimum specs",
                "recommended": "Recommended specs"
            }
        }
        """.utf8)

        let decoder = JSONDecoder()
        let platformInfo = try decoder.decode(PlatformInfo.self, from: json)

        #expect(platformInfo.platform.id == 4)
        #expect(platformInfo.releasedAt == "2020-12-10")
        #expect(platformInfo.requirements != nil)
        #expect(platformInfo.requirements?.minimum == "Minimum specs")
    }

    @Test("Achievement decodes from JSON and calculates percent")
    func achievementDecoding() throws {
        let json = Data("""
        {
            "id": 1,
            "name": "First Steps",
            "description": "Complete the tutorial",
            "image": "https://example.com/achievement.jpg",
            "percent": "85.5"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let achievement = try decoder.decode(Achievement.self, from: json)

        #expect(achievement.id == 1)
        #expect(achievement.name == "First Steps")
        #expect(achievement.percent == "85.5")
        #expect(achievement.percentValue == 85.5)
    }

    @Test("Store decodes from JSON")
    func storeDecoding() throws {
        let json = Data("""
        {
            "id": 1,
            "name": "Steam",
            "slug": "steam",
            "domain": "store.steampowered.com",
            "games_count": 50000,
            "image_background": "https://example.com/steam.jpg"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let store = try decoder.decode(Store.self, from: json)

        #expect(store.id == 1)
        #expect(store.name == "Steam")
        #expect(store.domain == "store.steampowered.com")
    }

    @Test("Creator decodes from JSON")
    func creatorDecoding() throws {
        let json = Data("""
        {
            "id": 78,
            "name": "Hideo Kojima",
            "slug": "hideo-kojima",
            "image": "https://example.com/kojima.jpg",
            "image_background": "https://example.com/kojima_bg.jpg",
            "games_count": 30
        }
        """.utf8)

        let decoder = JSONDecoder()
        let creator = try decoder.decode(Creator.self, from: json)

        #expect(creator.id == 78)
        #expect(creator.name == "Hideo Kojima")
        #expect(creator.gamesCount == 30)
    }

    @Test("Tag decodes from JSON")
    func tagDecoding() throws {
        let json = Data("""
        {
            "id": 31,
            "name": "Singleplayer",
            "slug": "singleplayer",
            "language": "eng",
            "games_count": 15000
        }
        """.utf8)

        let decoder = JSONDecoder()
        let tag = try decoder.decode(RAWGKit.Tag.self, from: json)

        #expect(tag.id == 31)
        #expect(tag.name == "Singleplayer")
        #expect(tag.language == "eng")
    }

    @Test("ESRBRating decodes from JSON")
    func esrbRatingDecoding() throws {
        let json = Data("""
        {
            "id": 4,
            "name": "Mature",
            "slug": "mature"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let rating = try decoder.decode(ESRBRating.self, from: json)

        #expect(rating.id == 4)
        #expect(rating.name == "Mature")
    }
}
