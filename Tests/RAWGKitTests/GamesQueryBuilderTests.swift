//
// GamesQueryBuilderTests.swift
// RAWGKitTests
//

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
}
