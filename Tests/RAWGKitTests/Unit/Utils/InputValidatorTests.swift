//
// InputValidatorTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("InputValidator Tests")
struct InputValidatorTests {
    // MARK: - Search Query Validation

    @Test("Valid search query passes validation")
    func validSearchQuery() throws {
        let query = "The Witcher 3"
        let result = try InputValidator.validateSearchQuery(query)
        #expect(result.contains("Witcher"))
    }

    @Test("Search query with special characters passes")
    func searchQueryWithSpecialCharacters() throws {
        let query = "Grand Theft Auto: Vice City"
        let result = try InputValidator.validateSearchQuery(query)
        #expect(!result.isEmpty)
    }

    @Test("Empty search query throws error")
    func emptySearchQueryThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSearchQuery("")
        }
    }

    @Test("Whitespace-only search query throws error")
    func whitespaceSearchQueryThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSearchQuery("   ")
        }
    }

    @Test("Search query exceeding max length throws error")
    func searchQueryTooLongThrowsError() {
        let longQuery = String(repeating: "a", count: 101)
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSearchQuery(longQuery)
        }
    }

    @Test("Search query with invalid characters throws error")
    func searchQueryWithInvalidCharactersThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSearchQuery("Test<script>alert('xss')</script>")
        }
    }

    // MARK: - Page Number Validation

    @Test("Valid page number passes validation")
    func validPageNumber() throws {
        let page = try InputValidator.validatePageNumber(1)
        #expect(page == 1)
    }

    @Test("Maximum page number passes validation")
    func maximumPageNumber() throws {
        let page = try InputValidator.validatePageNumber(10000)
        #expect(page == 10000)
    }

    @Test("Page number zero throws error")
    func pageNumberZeroThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validatePageNumber(0)
        }
    }

    @Test("Negative page number throws error")
    func negativePageNumberThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validatePageNumber(-1)
        }
    }

    @Test("Page number exceeding max throws error")
    func pageNumberExceedingMaxThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validatePageNumber(10001)
        }
    }

    // MARK: - Page Size Validation

    @Test("Valid page size passes validation")
    func validPageSize() throws {
        let pageSize = try InputValidator.validatePageSize(20)
        #expect(pageSize == 20)
    }

    @Test("Minimum page size passes validation")
    func minimumPageSize() throws {
        let pageSize = try InputValidator.validatePageSize(1)
        #expect(pageSize == 1)
    }

    @Test("Maximum page size passes validation")
    func maximumPageSize() throws {
        let pageSize = try InputValidator.validatePageSize(40)
        #expect(pageSize == 40)
    }

    @Test("Page size zero throws error")
    func pageSizeZeroThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validatePageSize(0)
        }
    }

    @Test("Page size exceeding max throws error")
    func pageSizeExceedingMaxThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validatePageSize(41)
        }
    }

    // MARK: - Resource ID Validation

    @Test("Valid resource ID passes validation")
    func validResourceID() throws {
        let id = try InputValidator.validateResourceID(12345)
        #expect(id == 12345)
    }

    @Test("Resource ID of 1 passes validation")
    func resourceIDOnePassesValidation() throws {
        let id = try InputValidator.validateResourceID(1)
        #expect(id == 1)
    }

    @Test("Resource ID zero throws error")
    func resourceIDZeroThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateResourceID(0)
        }
    }

    @Test("Negative resource ID throws error")
    func negativeResourceIDThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateResourceID(-1)
        }
    }

    // MARK: - Slug Validation

    @Test("Valid slug passes validation")
    func validSlug() throws {
        let slug = try InputValidator.validateSlug("grand-theft-auto-v")
        #expect(slug.contains("grand"))
    }

    @Test("Slug with numbers passes validation")
    func slugWithNumbers() throws {
        let slug = try InputValidator.validateSlug("fallout-4")
        #expect(slug.contains("fallout"))
    }

    @Test("Empty slug throws error")
    func emptySlugThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSlug("")
        }
    }

    @Test("Slug with uppercase throws error")
    func slugWithUppercaseThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSlug("Grand-Theft-Auto")
        }
    }

    @Test("Slug with spaces throws error")
    func slugWithSpacesThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSlug("grand theft auto")
        }
    }

    @Test("Slug with underscores throws error")
    func slugWithUnderscoresThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSlug("grand_theft_auto")
        }
    }

    @Test("Slug exceeding max length throws error")
    func slugTooLongThrowsError() {
        let longSlug = String(repeating: "a", count: 201)
        #expect(throws: NetworkError.self) {
            try InputValidator.validateSlug(longSlug)
        }
    }

    // MARK: - Metacritic Score Validation

    @Test("Valid Metacritic score passes validation")
    func validMetacriticScore() throws {
        let score = try InputValidator.validateMetacriticScore(85)
        #expect(score == 85)
    }

    @Test("Minimum Metacritic score passes validation")
    func minimumMetacriticScore() throws {
        let score = try InputValidator.validateMetacriticScore(0)
        #expect(score == 0)
    }

    @Test("Maximum Metacritic score passes validation")
    func maximumMetacriticScore() throws {
        let score = try InputValidator.validateMetacriticScore(100)
        #expect(score == 100)
    }

    @Test("Metacritic score below min throws error")
    func metacriticScoreBelowMinThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateMetacriticScore(-1)
        }
    }

    @Test("Metacritic score above max throws error")
    func metacriticScoreAboveMaxThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateMetacriticScore(101)
        }
    }

    // MARK: - Year Validation

    @Test("Valid year passes validation")
    func validYear() throws {
        let year = try InputValidator.validateYear(2023)
        #expect(year == 2023)
    }

    @Test("Current year passes validation")
    func currentYearPassesValidation() throws {
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = try InputValidator.validateYear(currentYear)
        #expect(year == currentYear)
    }

    @Test("Future year within limit passes validation")
    func futureYearPassesValidation() throws {
        let currentYear = Calendar.current.component(.year, from: Date())
        let futureYear = currentYear + 3
        let year = try InputValidator.validateYear(futureYear)
        #expect(year == futureYear)
    }

    @Test("Year 1970 passes validation")
    func year1970PassesValidation() throws {
        let year = try InputValidator.validateYear(1970)
        #expect(year == 1970)
    }

    @Test("Year before 1970 throws error")
    func yearBefore1970ThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateYear(1969)
        }
    }

    @Test("Year too far in future throws error")
    func yearTooFarInFutureThrowsError() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let farFutureYear = currentYear + 10
        #expect(throws: NetworkError.self) {
            try InputValidator.validateYear(farFutureYear)
        }
    }

    // MARK: - Date String Validation

    @Test("Valid date string passes validation")
    func validDateString() throws {
        let date = try InputValidator.validateDateString("2023-12-25")
        #expect(date == "2023-12-25")
    }

    @Test("Valid date at start of month passes")
    func validDateAtStartOfMonth() throws {
        let date = try InputValidator.validateDateString("2023-01-01")
        #expect(date == "2023-01-01")
    }

    @Test("Valid date at end of month passes")
    func validDateAtEndOfMonth() throws {
        let date = try InputValidator.validateDateString("2023-12-31")
        #expect(date == "2023-12-31")
    }

    @Test("Invalid date format throws error")
    func invalidDateFormatThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateDateString("25-12-2023")
        }
    }

    @Test("Invalid date without hyphens throws error")
    func invalidDateWithoutHyphensThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateDateString("20231225")
        }
    }

    @Test("Invalid date with month 13 throws error")
    func invalidMonth13ThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateDateString("2023-13-01")
        }
    }

    @Test("Invalid date with day 32 throws error")
    func invalidDay32ThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateDateString("2023-01-32")
        }
    }

    @Test("Invalid leap year date throws error")
    func invalidLeapYearDateThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateDateString("2023-02-29")
        }
    }

    // MARK: - ID Array Validation

    @Test("Valid ID array passes validation")
    func validIDArray() throws {
        let ids = try InputValidator.validateIDArray([1, 2, 3, 4, 5])
        #expect(ids.count == 5)
    }

    @Test("Single element ID array passes validation")
    func singleElementIDArray() throws {
        let ids = try InputValidator.validateIDArray([42])
        #expect(ids.count == 1)
        #expect(ids[0] == 42)
    }

    @Test("Empty ID array throws error")
    func emptyIDArrayThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateIDArray([])
        }
    }

    @Test("ID array exceeding max size throws error")
    func idArrayExceedingMaxSizeThrowsError() {
        let largeArray = Array(1 ... 51)
        #expect(throws: NetworkError.self) {
            try InputValidator.validateIDArray(largeArray)
        }
    }

    @Test("ID array with zero throws error")
    func idArrayWithZeroThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateIDArray([1, 0, 3])
        }
    }

    @Test("ID array with negative number throws error")
    func idArrayWithNegativeThrowsError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateIDArray([1, -1, 3])
        }
    }

    // MARK: - Comma-Separated Values Validation

    @Test("Valid comma-separated values pass validation")
    func validCommaSeparatedValues() throws {
        let values = try InputValidator.validateCommaSeparatedValues("rockstar-games,ea-sports")
        #expect(values.contains("rockstar"))
    }

    @Test("Single value passes validation")
    func singleValuePassesValidation() throws {
        let values = try InputValidator.validateCommaSeparatedValues("rockstar-games")
        #expect(values.contains("rockstar"))
    }

    @Test("Values with numbers pass validation")
    func valuesWithNumbersPassValidation() throws {
        let values = try InputValidator.validateCommaSeparatedValues("studio-1,studio-2")
        #expect(!values.isEmpty)
    }

    @Test("Empty comma-separated values throw error")
    func emptyCommaSeparatedValuesThrowError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateCommaSeparatedValues("")
        }
    }

    @Test("Comma-separated values exceeding max items throws error")
    func commaSeparatedValuesExceedingMaxItemsThrowsError() {
        let manyValues = (1 ... 51).map { "value-\($0)" }.joined(separator: ",")
        #expect(throws: NetworkError.self) {
            try InputValidator.validateCommaSeparatedValues(manyValues)
        }
    }

    @Test("Comma-separated values with invalid characters throw error")
    func commaSeparatedValuesWithInvalidCharactersThrowError() {
        #expect(throws: NetworkError.self) {
            try InputValidator.validateCommaSeparatedValues("value<script>,test")
        }
    }

    // MARK: - Edge Cases

    @Test("Search query trims whitespace correctly")
    func searchQueryTrimsWhitespace() throws {
        let result = try InputValidator.validateSearchQuery("  The Witcher 3  ")
        #expect(result.contains("Witcher"))
    }

    @Test("Date string trims whitespace correctly")
    func dateStringTrimsWhitespace() throws {
        let date = try InputValidator.validateDateString("  2023-12-25  ")
        #expect(date == "2023-12-25")
    }

    @Test("Slug trims whitespace correctly")
    func slugTrimsWhitespace() throws {
        let slug = try InputValidator.validateSlug("  fallout-4  ")
        #expect(slug.contains("fallout"))
    }

    @Test("Search query with apostrophes passes")
    func searchQueryWithApostrophe() throws {
        let result = try InputValidator.validateSearchQuery("Assassin's Creed")
        #expect(result.contains("Assassin"))
    }

    @Test("Search query with quotes passes")
    func searchQueryWithQuotes() throws {
        let result = try InputValidator.validateSearchQuery("The \"Legend\" of Zelda")
        #expect(!result.isEmpty)
    }

    @Test("Search query with ampersand passes")
    func searchQueryWithAmpersand() throws {
        let result = try InputValidator.validateSearchQuery("Dungeons & Dragons")
        #expect(!result.isEmpty)
    }

    @Test("Validates maximum allowed ID array size")
    func validatesMaximumIDArraySize() throws {
        let maxArray = Array(1 ... 50)
        let ids = try InputValidator.validateIDArray(maxArray)
        #expect(ids.count == 50)
    }

    @Test("Validates maximum allowed year")
    func validatesMaximumYear() throws {
        let currentYear = Calendar.current.component(.year, from: Date())
        let maxYear = currentYear + 5
        let year = try InputValidator.validateYear(maxYear)
        #expect(year == maxYear)
    }
}
