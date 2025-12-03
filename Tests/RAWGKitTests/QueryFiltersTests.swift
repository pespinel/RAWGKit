//
// QueryFiltersTests.swift
// RAWGKitTests
//

@testable import RAWGKit
import Testing

@Suite("QueryFilters Tests")
struct QueryFiltersTests {
    // MARK: - KnownPlatform Tests

    @Test("KnownPlatform has correct raw values")
    func knownPlatformRawValues() {
        #expect(KnownPlatform.pc.rawValue == 4)
        #expect(KnownPlatform.playStation5.rawValue == 187)
        #expect(KnownPlatform.playStation4.rawValue == 18)
        #expect(KnownPlatform.xboxSeriesX.rawValue == 186)
        #expect(KnownPlatform.xboxOne.rawValue == 1)
        #expect(KnownPlatform.nintendoSwitch.rawValue == 7)
        #expect(KnownPlatform.iOS.rawValue == 3)
        #expect(KnownPlatform.android.rawValue == 21)
    }

    @Test("KnownPlatform provides display names")
    func knownPlatformNames() {
        #expect(KnownPlatform.pc.name == "PC")
        #expect(KnownPlatform.playStation5.name == "PlayStation 5")
        #expect(KnownPlatform.nintendoSwitch.name == "Nintendo Switch")
        #expect(KnownPlatform.xboxSeriesX.name == "Xbox Series S/X")
    }

    @Test("KnownPlatform is CaseIterable")
    func knownPlatformCaseIterable() {
        #expect(!KnownPlatform.allCases.isEmpty)
        #expect(KnownPlatform.allCases.contains(.pc))
        #expect(KnownPlatform.allCases.contains(.playStation5))
    }

    // MARK: - KnownParentPlatform Tests

    @Test("KnownParentPlatform has correct raw values")
    func knownParentPlatformRawValues() {
        #expect(KnownParentPlatform.pc.rawValue == 1)
        #expect(KnownParentPlatform.playStation.rawValue == 2)
        #expect(KnownParentPlatform.xbox.rawValue == 3)
        #expect(KnownParentPlatform.nintendo.rawValue == 7)
        #expect(KnownParentPlatform.sega.rawValue == 11)
    }

    @Test("KnownParentPlatform provides display names")
    func knownParentPlatformNames() {
        #expect(KnownParentPlatform.pc.name == "PC")
        #expect(KnownParentPlatform.playStation.name == "PlayStation")
        #expect(KnownParentPlatform.nintendo.name == "Nintendo")
        #expect(KnownParentPlatform.sega.name == "SEGA")
    }

    // MARK: - KnownGenre Tests

    @Test("KnownGenre has correct raw values")
    func knownGenreRawValues() {
        #expect(KnownGenre.action.rawValue == 4)
        #expect(KnownGenre.adventure.rawValue == 3)
        #expect(KnownGenre.rpg.rawValue == 5)
        #expect(KnownGenre.shooter.rawValue == 2)
        #expect(KnownGenre.indie.rawValue == 51)
    }

    @Test("KnownGenre provides display names")
    func knownGenreNames() {
        #expect(KnownGenre.action.name == "Action")
        #expect(KnownGenre.rpg.name == "RPG")
        #expect(KnownGenre.massivelyMultiplayer.name == "Massively Multiplayer")
    }

    // MARK: - KnownStore Tests

    @Test("KnownStore has correct raw values")
    func knownStoreRawValues() {
        #expect(KnownStore.steam.rawValue == 1)
        #expect(KnownStore.playStationStore.rawValue == 3)
        #expect(KnownStore.epicGames.rawValue == 11)
        #expect(KnownStore.gog.rawValue == 5)
        #expect(KnownStore.nintendoStore.rawValue == 6)
    }

    @Test("KnownStore provides display names")
    func knownStoreNames() {
        #expect(KnownStore.steam.name == "Steam")
        #expect(KnownStore.epicGames.name == "Epic Games")
        #expect(KnownStore.itchIO.name == "itch.io")
    }

    // MARK: - GameOrdering Tests

    @Test("GameOrdering has correct raw values")
    func gameOrderingRawValues() {
        #expect(GameOrdering.name.rawValue == "name")
        #expect(GameOrdering.nameDescending.rawValue == "-name")
        #expect(GameOrdering.released.rawValue == "released")
        #expect(GameOrdering.releasedDescending.rawValue == "-released")
        #expect(GameOrdering.metacritic.rawValue == "metacritic")
        #expect(GameOrdering.metacriticDescending.rawValue == "-metacritic")
        #expect(GameOrdering.rating.rawValue == "rating")
        #expect(GameOrdering.ratingDescending.rawValue == "-rating")
    }
}
