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
        // Verify that multiple methods can be chained without errors
        _ = GamesQueryBuilder()
            .page(2)
            .pageSize(30)
            .search("zelda")
            .orderByRating()
            .year(2023)
            .platforms([4, 18])
            .genres([4])
            .metacriticMin(85)
            .excludeAdditions()
    }

    @Test("Ordering methods work correctly")
    func orderingMethods() {
        _ = GamesQueryBuilder().orderByName()
        _ = GamesQueryBuilder().orderByNewest()
        _ = GamesQueryBuilder().orderByRating()
        _ = GamesQueryBuilder().orderByMetacritic()
    }

    @Test("Year method works correctly")
    func yearMethod() {
        _ = GamesQueryBuilder().year(2023)
    }

    @Test("Metacritic min method works correctly")
    func metacriticMinMethod() {
        _ = GamesQueryBuilder().metacriticMin(80)
    }

    // MARK: - Type-Safe Platform Tests

    @Test("Type-safe platforms method works correctly")
    func typeSafePlatformsMethod() {
        _ = GamesQueryBuilder()
            .platforms([.pc, .playStation5, .xboxSeriesX])
    }

    @Test("Type-safe parent platforms method works correctly")
    func typeSafeParentPlatformsMethod() {
        _ = GamesQueryBuilder()
            .parentPlatforms([.playStation, .xbox, .nintendo])
    }

    // MARK: - Type-Safe Genre Tests

    @Test("Type-safe genres method works correctly")
    func typeSafeGenresMethod() {
        _ = GamesQueryBuilder()
            .genres([.action, .rpg, .adventure])
    }

    // MARK: - Type-Safe Store Tests

    @Test("Type-safe stores method works correctly")
    func typeSafeStoresMethod() {
        _ = GamesQueryBuilder()
            .stores([.steam, .epicGames, .gog])
    }

    // MARK: - Type-Safe Ordering Tests

    @Test("Type-safe ordering method works correctly")
    func typeSafeOrderingMethod() {
        _ = GamesQueryBuilder().ordering(.metacriticDescending)
        _ = GamesQueryBuilder().ordering(.ratingDescending)
        _ = GamesQueryBuilder().ordering(.releasedDescending)
    }

    // MARK: - Date Helper Tests

    @Test("releasedThisYear method works correctly")
    func releasedThisYearMethod() {
        _ = GamesQueryBuilder().releasedThisYear()
    }

    @Test("releasedBetween method works with Date objects")
    func releasedBetweenMethod() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

        _ = GamesQueryBuilder()
            .releasedBetween(from: startDate, to: endDate)
    }

    @Test("releasedAfter method works correctly")
    func releasedAfterMethod() {
        let date = Calendar.current.date(from: DateComponents(year: 2020, month: 1, day: 1))!
        _ = GamesQueryBuilder().releasedAfter(date)
    }

    @Test("releasedBefore method works correctly")
    func releasedBeforeMethod() {
        let date = Calendar.current.date(from: DateComponents(year: 2020, month: 12, day: 31))!
        _ = GamesQueryBuilder().releasedBefore(date)
    }

    @Test("releasedInLast days method works correctly")
    func releasedInLastDaysMethod() {
        _ = GamesQueryBuilder().releasedInLast(days: 30)
    }

    @Test("updatedBetween method works correctly")
    func updatedBetweenMethod() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 6, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

        _ = GamesQueryBuilder()
            .updatedBetween(from: startDate, to: endDate)
    }

    // MARK: - Metacritic Range Tests

    @Test("Metacritic range method works correctly")
    func metacriticRangeMethod() {
        _ = GamesQueryBuilder()
            .metacritic(min: 80, max: 100)
    }

    @Test("Metacritic range clamps values correctly")
    func metacriticRangeClamping() {
        // Should not crash with out-of-range values
        _ = GamesQueryBuilder()
            .metacritic(min: -10, max: 150)
    }

    // MARK: - Complex Query Tests

    @Test("Complex type-safe query builder works correctly")
    func complexTypeSafeQuery() {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

        // Verify all filters can be chained together
        _ = GamesQueryBuilder()
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
    }
}
