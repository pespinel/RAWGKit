//
// ResourceDetailsModelsTests2.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Resource Details Models Tests - Part 2")
struct ResourceDetailsModelsTests2 {
    // MARK: - StoreDetails Tests

    @Test("StoreDetails initializes with all fields")
    func storeDetailsInitialization() {
        let store = StoreDetails(
            id: 1,
            name: "Steam",
            slug: "steam",
            domain: "store.steampowered.com",
            gamesCount: 50000,
            imageBackground: "https://example.com/steam_bg.jpg",
            description: "<p>Largest PC gaming platform</p>"
        )

        #expect(store.id == 1)
        #expect(store.name == "Steam")
        #expect(store.slug == "steam")
        #expect(store.domain == "store.steampowered.com")
        #expect(store.gamesCount == 50000)
        #expect(store.imageBackground == "https://example.com/steam_bg.jpg")
        #expect(store.description == "<p>Largest PC gaming platform</p>")
    }

    @Test("StoreDetails initializes with minimal fields")
    func storeDetailsMinimalInitialization() {
        let store = StoreDetails(
            id: 1,
            name: "Epic Games",
            slug: "epic-games"
        )

        #expect(store.id == 1)
        #expect(store.name == "Epic Games")
        #expect(store.slug == "epic-games")
        #expect(store.domain == nil)
        #expect(store.gamesCount == nil)
        #expect(store.imageBackground == nil)
        #expect(store.description == nil)
    }

    @Test("StoreDetails decodes from JSON")
    func storeDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 1,
            "name": "Steam",
            "slug": "steam",
            "domain": "store.steampowered.com",
            "games_count": 50000,
            "image_background": "https://example.com/steam_bg.jpg",
            "description": "<p>Largest PC gaming platform</p>"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let store = try decoder.decode(StoreDetails.self, from: json)

        #expect(store.id == 1)
        #expect(store.name == "Steam")
        #expect(store.gamesCount == 50000)
    }

    @Test("StoreDetails handles missing domain")
    func storeDetailsMissingDomain() throws {
        let json = Data("""
        {
            "id": 1,
            "name": "Console Store",
            "slug": "console-store"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let store = try decoder.decode(StoreDetails.self, from: json)

        #expect(store.domain == nil)
    }

    // MARK: - TagDetails Tests

    @Test("TagDetails initializes with all fields")
    func tagDetailsInitialization() {
        let tag = TagDetails(
            id: 31,
            name: "Singleplayer",
            slug: "singleplayer",
            gamesCount: 15000,
            imageBackground: "https://example.com/singleplayer_bg.jpg",
            description: "<p>Games designed for solo play</p>",
            language: "eng"
        )

        #expect(tag.id == 31)
        #expect(tag.name == "Singleplayer")
        #expect(tag.slug == "singleplayer")
        #expect(tag.language == "eng")
        #expect(tag.gamesCount == 15000)
        #expect(tag.imageBackground == "https://example.com/singleplayer_bg.jpg")
        #expect(tag.description == "<p>Games designed for solo play</p>")
    }

    @Test("TagDetails initializes with minimal fields")
    func tagDetailsMinimalInitialization() {
        let tag = TagDetails(
            id: 1,
            name: "Action",
            slug: "action",
            gamesCount: 1000,
            language: "eng"
        )

        #expect(tag.id == 1)
        #expect(tag.name == "Action")
        #expect(tag.slug == "action")
        #expect(tag.language == "eng")
        #expect(tag.gamesCount == 1000)
        #expect(tag.imageBackground == nil)
        #expect(tag.description == nil)
    }

    @Test("TagDetails decodes from JSON")
    func tagDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 31,
            "name": "Singleplayer",
            "slug": "singleplayer",
            "language": "eng",
            "games_count": 15000,
            "image_background": "https://example.com/singleplayer_bg.jpg",
            "description": "<p>Games designed for solo play</p>"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let tag = try decoder.decode(TagDetails.self, from: json)

        #expect(tag.id == 31)
        #expect(tag.name == "Singleplayer")
        #expect(tag.gamesCount == 15000)
    }

    @Test("TagDetails handles non-English language")
    func tagDetailsNonEnglishLanguage() {
        let tag = TagDetails(
            id: 1,
            name: "Multijugador",
            slug: "multijugador",
            gamesCount: 5000,
            language: "spa"
        )

        #expect(tag.language == "spa")
    }

    // MARK: - GenreDetails Tests

    @Test("GenreDetails initializes with all fields")
    func genreDetailsInitialization() {
        let genre = GenreDetails(
            id: 4,
            name: "Action",
            slug: "action",
            gamesCount: 12345,
            imageBackground: "https://example.com/action_bg.jpg",
            description: "<p>Fast-paced gameplay</p>"
        )

        #expect(genre.id == 4)
        #expect(genre.name == "Action")
        #expect(genre.slug == "action")
        #expect(genre.gamesCount == 12345)
        #expect(genre.imageBackground == "https://example.com/action_bg.jpg")
        #expect(genre.description == "<p>Fast-paced gameplay</p>")
    }

    @Test("GenreDetails initializes with minimal fields")
    func genreDetailsMinimalInitialization() {
        let genre = GenreDetails(
            id: 1,
            name: "Adventure",
            slug: "adventure"
        )

        #expect(genre.id == 1)
        #expect(genre.name == "Adventure")
        #expect(genre.slug == "adventure")
        #expect(genre.gamesCount == nil)
        #expect(genre.imageBackground == nil)
        #expect(genre.description == nil)
    }

    @Test("GenreDetails decodes from JSON")
    func genreDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 4,
            "name": "Action",
            "slug": "action",
            "games_count": 12345,
            "image_background": "https://example.com/action_bg.jpg",
            "description": "<p>Fast-paced gameplay</p>"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let genre = try decoder.decode(GenreDetails.self, from: json)

        #expect(genre.id == 4)
        #expect(genre.name == "Action")
        #expect(genre.gamesCount == 12345)
    }

    // MARK: - PlatformDetails Tests

    @Test("PlatformDetails initializes with all fields")
    func platformDetailsInitialization() {
        let platform = PlatformDetails(
            id: 4,
            name: "PC",
            slug: "pc",
            gamesCount: 50000,
            imageBackground: "https://example.com/pc_bg.jpg",
            description: "<p>Personal computer gaming</p>",
            yearStart: 1980,
            yearEnd: nil
        )

        #expect(platform.id == 4)
        #expect(platform.name == "PC")
        #expect(platform.slug == "pc")
        #expect(platform.gamesCount == 50000)
        #expect(platform.imageBackground == "https://example.com/pc_bg.jpg")
        #expect(platform.description == "<p>Personal computer gaming</p>")
        #expect(platform.yearStart == 1980)
        #expect(platform.yearEnd == nil)
    }

    @Test("PlatformDetails initializes with minimal fields")
    func platformDetailsMinimalInitialization() {
        let platform = PlatformDetails(
            id: 1,
            name: "PlayStation 5",
            slug: "playstation5"
        )

        #expect(platform.id == 1)
        #expect(platform.name == "PlayStation 5")
        #expect(platform.slug == "playstation5")
        #expect(platform.gamesCount == nil)
        #expect(platform.imageBackground == nil)
        #expect(platform.description == nil)
        #expect(platform.yearStart == nil)
        #expect(platform.yearEnd == nil)
    }

    @Test("PlatformDetails decodes from JSON")
    func platformDetailsDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 4,
            "name": "PC",
            "slug": "pc",
            "games_count": 50000,
            "image_background": "https://example.com/pc_bg.jpg",
            "description": "<p>Personal computer gaming</p>",
            "year_start": 1980,
            "year_end": null
        }
        """.utf8)

        let decoder = JSONDecoder()
        let platform = try decoder.decode(PlatformDetails.self, from: json)

        #expect(platform.id == 4)
        #expect(platform.name == "PC")
        #expect(platform.gamesCount == 50000)
        #expect(platform.yearStart == 1980)
    }
}
