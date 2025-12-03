//
// GameTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Game Model Tests")
struct GameTests {
    @Test("Game decodes from JSON correctly")
    func gameDecoding() throws {
        let json = Data("""
        {
            "id": 3498,
            "name": "Grand Theft Auto V",
            "slug": "grand-theft-auto-v",
            "background_image": "https://example.com/image.jpg",
            "released": "2013-09-17",
            "rating": 4.47,
            "rating_top": 5,
            "ratings_count": 5000,
            "metacritic": 97,
            "playtime": 73
        }
        """.utf8)

        let decoder = JSONDecoder()
        let game = try decoder.decode(Game.self, from: json)

        #expect(game.id == 3498)
        #expect(game.name == "Grand Theft Auto V")
        #expect(game.slug == "grand-theft-auto-v")
        #expect(game.rating == 4.47)
        #expect(game.metacritic == 97)
        #expect(game.isHighlyRated == true)
    }

    @Test("Game with high rating returns true for isHighlyRated")
    func gameIsHighlyRated() {
        let highRatedGame = Game(
            id: 1,
            name: "Test Game",
            slug: "test-game",
            rating: 4.5
        )
        #expect(highRatedGame.isHighlyRated == true)

        let lowRatedGame = Game(
            id: 2,
            name: "Test Game 2",
            slug: "test-game-2",
            rating: 3.5
        )
        #expect(lowRatedGame.isHighlyRated == false)
    }

    @Test("Game platform names shows first 3 platforms")
    func gamePlatformNames() {
        let platform1 = Platform(id: 4, name: "PC", slug: "pc")
        let platform2 = Platform(id: 18, name: "PlayStation 4", slug: "playstation4")
        let platform3 = Platform(id: 1, name: "Xbox One", slug: "xbox-one")
        let platform4 = Platform(id: 7, name: "Nintendo Switch", slug: "nintendo-switch")

        let platformInfo1 = PlatformInfo(platform: platform1)
        let platformInfo2 = PlatformInfo(platform: platform2)
        let platformInfo3 = PlatformInfo(platform: platform3)
        let platformInfo4 = PlatformInfo(platform: platform4)

        let game = Game(
            id: 1,
            name: "Test Game",
            slug: "test-game",
            rating: 4.5,
            platforms: [platformInfo1, platformInfo2, platformInfo3, platformInfo4]
        )

        #expect(game.platformNames == "PC, PlayStation 4, Xbox One")
    }
}
