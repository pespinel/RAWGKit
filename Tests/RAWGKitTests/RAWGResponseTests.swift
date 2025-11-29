//
// RAWGResponseTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("RAWGResponse Tests")
struct RAWGResponseTests {
    @Test("RAWGResponse decodes from JSON with pagination")
    func responseDecoding() throws {
        let json = """
        {
            "count": 100,
            "next": "https://api.rawg.io/api/games?page=2",
            "previous": null,
            "results": [
                {
                    "id": 1,
                    "name": "Test Game",
                    "slug": "test-game",
                    "rating": 4.5
                }
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(RAWGResponse<Game>.self, from: json)

        #expect(response.count == 100)
        #expect(response.next != nil)
        #expect(response.previous == nil)
        #expect(response.results.count == 1)
        #expect(response.results.first?.name == "Test Game")
        #expect(response.hasNextPage == true)
    }

    @Test("RAWGResponse detects no next page")
    func responseNoNextPage() throws {
        let json = """
        {
            "count": 10,
            "next": null,
            "previous": "https://api.rawg.io/api/games?page=1",
            "results": []
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(RAWGResponse<Game>.self, from: json)

        #expect(response.hasNextPage == false)
    }
}
