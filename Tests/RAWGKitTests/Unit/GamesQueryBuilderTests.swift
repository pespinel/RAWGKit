//
// GamesQueryBuilderTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("GamesQueryBuilder Tests")
struct GamesQueryBuilderTests {
    @Test("Query builder supports method chaining")
    func queryBuilderChaining() {
        let builder = GamesQueryBuilder()
            .page(2)
            .pageSize(30)
            .search("zelda")
            .orderByRating()
            .year(2023)
            .platforms([4, 18])
            .genres([4])
            .metacriticMin(85)
            .excludeAdditions()

        #expect(builder != nil)
    }

    @Test("Ordering methods work correctly")
    func orderingMethods() {
        let byName = GamesQueryBuilder().orderByName()
        #expect(byName != nil)

        let byNewest = GamesQueryBuilder().orderByNewest()
        #expect(byNewest != nil)

        let byRating = GamesQueryBuilder().orderByRating()
        #expect(byRating != nil)

        let byMetacritic = GamesQueryBuilder().orderByMetacritic()
        #expect(byMetacritic != nil)
    }

    @Test("Year method works correctly")
    func yearMethod() {
        let builder = GamesQueryBuilder().year(2023)
        #expect(builder != nil)
    }

    @Test("Metacritic min method works correctly")
    func metacriticMinMethod() {
        let builder = GamesQueryBuilder().metacriticMin(80)
        #expect(builder != nil)
    }

    // MARK: - Type-Safe Platform Tests

    @Test("Type-safe platforms method works correctly")
    func typeSafePlatforms() {
        let builder = GamesQueryBuilder()
            .platforms([.pc, .playStation5, .xboxSeriesX])

        #expect(builder != nil)
    }

    @Test("Type-safe parent platforms method works correctly")
    func typeSafeParentPlatforms() {
        let builder = GamesQueryBuilder()
            .parentPlatforms([.playStation, .xbox, .nintendo])

        #expect(builder != nil)
    }

    // MARK: - Type-Safe Genre Tests

    @Test("Type-safe genres method works correctly")
    func typeSafeGenres() {
        let builder = GamesQueryBuilder()
            .genres([.action, .rpg, .adventure])

        #expect(builder != nil)
    }

    // MARK: - Type-Safe Store Tests

    @Test("Type-safe stores method works correctly")
    func typeSafeStores() {
        let builder = GamesQueryBuilder()
            .stores([.steam, .epicGames, .gog])

        #expect(builder != nil)
    }

    // MARK: - Type-Safe Ordering Tests

    @Test("Type-safe ordering method works correctly")
    func typeSafeOrdering() {
        let byMetacritic = GamesQueryBuilder()
            .ordering(.metacriticDescending)
        #expect(byMetacritic != nil)

        let byRating = GamesQueryBuilder()
            .ordering(.ratingDescending)
        #expect(byRating != nil)

        let byReleased = GamesQueryBuilder()
            .ordering(.releasedDescending)
        #expect(byReleased != nil)
    }

    // MARK: - Date Helper Tests

    @Test("releasedThisYear method works correctly")
    func releasedThisYearMethod() {
        let builder = GamesQueryBuilder().releasedThisYear()
        #expect(builder != nil)
    }

    @Test("releasedBetween method works with Date objects")
    func releasedBetweenMethod() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

        let builder = GamesQueryBuilder()
            .releasedBetween(from: startDate, to: endDate)

        #expect(builder != nil)
    }

    @Test("releasedAfter method works correctly")
    func releasedAfterMethod() {
        let date = Calendar.current.date(from: DateComponents(year: 2020, month: 1, day: 1))!
        let builder = GamesQueryBuilder().releasedAfter(date)
        #expect(builder != nil)
    }

    @Test("releasedBefore method works correctly")
    func releasedBeforeMethod() {
        let date = Calendar.current.date(from: DateComponents(year: 2020, month: 12, day: 31))!
        let builder = GamesQueryBuilder().releasedBefore(date)
        #expect(builder != nil)
    }

    @Test("releasedInLast days method works correctly")
    func releasedInLastDaysMethod() {
        let builder = GamesQueryBuilder().releasedInLast(days: 30)
        #expect(builder != nil)
    }

    @Test("updatedBetween method works correctly")
    func updatedBetweenMethod() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 6, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

        let builder = GamesQueryBuilder()
            .updatedBetween(from: startDate, to: endDate)

        #expect(builder != nil)
    }

    // MARK: - Metacritic Range Tests

    @Test("Metacritic range method works correctly")
    func metacriticRangeMethod() {
        let builder = GamesQueryBuilder()
            .metacritic(min: 80, max: 100)

        #expect(builder != nil)
    }

    @Test("Metacritic range clamps values correctly")
    func metacriticRangeClamping() {
        // Should not crash with out-of-range values
        let builder = GamesQueryBuilder()
            .metacritic(min: -10, max: 150)

        #expect(builder != nil)
    }

    // MARK: - Complex Query Tests

    @Test("Complex type-safe query builder works correctly")
    func complexTypeSafeQuery() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

        let builder = GamesQueryBuilder()
            .search("zelda")
            .platforms([.nintendoSwitch, .wiiU])
            .parentPlatforms([.nintendo])
            .genres([.action, .adventure])
            .stores([.nintendoStore])
            .releasedBetween(from: startDate, to: endDate)
            .ordering(.metacriticDescending)
            .metacritic(min: 85, max: 100)
            .pageSize(20)
            .excludeAdditions()

        #expect(builder != nil)
    }
}
