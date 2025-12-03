//
// QueryFilters.swift
// RAWGKit
//

import Foundation

// MARK: - Known Platforms

/// Well-known platform IDs from RAWG API for type-safe queries
public enum KnownPlatform: Int, CaseIterable, Sendable {
    // PC
    case pc = 4
    case macOS = 5
    case linux = 6

    // PlayStation
    case playStation5 = 187
    case playStation4 = 18
    case playStation3 = 16
    case playStation2 = 27
    case psVita = 19
    case psp = 17

    // Xbox
    case xboxSeriesX = 186
    case xboxOne = 1
    case xbox360 = 14
    case xboxOriginal = 80

    // Nintendo
    case nintendoSwitch = 7
    case wiiU = 10
    case wii = 11
    case nintendo3DS = 8
    case nintendoDS = 9
    case gameCube = 105
    case nintendo64 = 83
    case snes = 79
    case nes = 49
    case gameboyAdvance = 24
    case gameboy = 26
    case gameboyColor = 43

    // Mobile
    case iOS = 3
    case android = 21

    // SEGA
    case dreamcast = 106
    case segaSaturn = 107
    case genesis = 167
    case segaMasterSystem = 168
    case gameGear = 169

    // Other
    case web = 171

    /// Platform name for display
    public var name: String {
        switch self {
        case .pc: "PC"
        case .macOS: "macOS"
        case .linux: "Linux"
        case .playStation5: "PlayStation 5"
        case .playStation4: "PlayStation 4"
        case .playStation3: "PlayStation 3"
        case .playStation2: "PlayStation 2"
        case .psVita: "PS Vita"
        case .psp: "PSP"
        case .xboxSeriesX: "Xbox Series S/X"
        case .xboxOne: "Xbox One"
        case .xbox360: "Xbox 360"
        case .xboxOriginal: "Xbox"
        case .nintendoSwitch: "Nintendo Switch"
        case .wiiU: "Wii U"
        case .wii: "Wii"
        case .nintendo3DS: "Nintendo 3DS"
        case .nintendoDS: "Nintendo DS"
        case .gameCube: "GameCube"
        case .nintendo64: "Nintendo 64"
        case .snes: "SNES"
        case .nes: "NES"
        case .gameboy: "Game Boy"
        case .gameboyColor: "Game Boy Color"
        case .gameboyAdvance: "Game Boy Advance"
        case .iOS: "iOS"
        case .android: "Android"
        case .dreamcast: "Dreamcast"
        case .segaSaturn: "SEGA Saturn"
        case .genesis: "Genesis"
        case .segaMasterSystem: "SEGA Master System"
        case .gameGear: "Game Gear"
        case .web: "Web"
        }
    }
}

// MARK: - Known Parent Platforms

/// Parent platform categories from RAWG API
public enum KnownParentPlatform: Int, CaseIterable, Sendable {
    case pc = 1
    case playStation = 2
    case xbox = 3
    case iOS = 4
    case mac = 5
    case linux = 6
    case nintendo = 7
    case android = 8
    case atari = 9
    case commodoreAmiga = 10
    case sega = 11
    case threeDO = 12
    case neoGeo = 13
    case web = 14

    /// Platform name for display
    public var name: String {
        switch self {
        case .pc: "PC"
        case .playStation: "PlayStation"
        case .xbox: "Xbox"
        case .iOS: "iOS"
        case .mac: "Apple Macintosh"
        case .linux: "Linux"
        case .nintendo: "Nintendo"
        case .android: "Android"
        case .atari: "Atari"
        case .commodoreAmiga: "Commodore / Amiga"
        case .sega: "SEGA"
        case .threeDO: "3DO"
        case .neoGeo: "Neo Geo"
        case .web: "Web"
        }
    }
}

// MARK: - Known Genres

/// Well-known genre IDs from RAWG API
public enum KnownGenre: Int, CaseIterable, Sendable {
    case action = 4
    case adventure = 3
    case rpg = 5
    case shooter = 2
    case puzzle = 7
    case racing = 1
    case sports = 15
    case strategy = 10
    case simulation = 14
    case fighting = 6
    case platformer = 83
    case arcade = 11
    case indie = 51
    case massivelyMultiplayer = 59
    case casual = 40
    case family = 19
    case boardGames = 28
    case card = 17
    case educational = 34

    /// Genre name for display
    public var name: String {
        switch self {
        case .action: "Action"
        case .adventure: "Adventure"
        case .rpg: "RPG"
        case .shooter: "Shooter"
        case .puzzle: "Puzzle"
        case .racing: "Racing"
        case .sports: "Sports"
        case .strategy: "Strategy"
        case .simulation: "Simulation"
        case .fighting: "Fighting"
        case .platformer: "Platformer"
        case .arcade: "Arcade"
        case .indie: "Indie"
        case .massivelyMultiplayer: "Massively Multiplayer"
        case .casual: "Casual"
        case .family: "Family"
        case .boardGames: "Board Games"
        case .card: "Card"
        case .educational: "Educational"
        }
    }
}

// MARK: - Known Stores

/// Well-known store IDs from RAWG API
public enum KnownStore: Int, CaseIterable, Sendable {
    case steam = 1
    case xboxStore = 2
    case playStationStore = 3
    case appStore = 4
    case gog = 5
    case nintendoStore = 6
    case xbox360Store = 7
    case googlePlay = 8
    case itchIO = 9
    case epicGames = 11

    /// Store name for display
    public var name: String {
        switch self {
        case .steam: "Steam"
        case .xboxStore: "Xbox Store"
        case .playStationStore: "PlayStation Store"
        case .appStore: "App Store"
        case .gog: "GOG"
        case .nintendoStore: "Nintendo Store"
        case .xbox360Store: "Xbox 360 Store"
        case .googlePlay: "Google Play"
        case .itchIO: "itch.io"
        case .epicGames: "Epic Games"
        }
    }
}

// MARK: - Ordering Options

/// Type-safe ordering options for game queries
public enum GameOrdering: String, Sendable {
    case name
    case nameDescending = "-name"
    case released
    case releasedDescending = "-released"
    case added
    case addedDescending = "-added"
    case created
    case createdDescending = "-created"
    case updated
    case updatedDescending = "-updated"
    case rating
    case ratingDescending = "-rating"
    case metacritic
    case metacriticDescending = "-metacritic"
}
