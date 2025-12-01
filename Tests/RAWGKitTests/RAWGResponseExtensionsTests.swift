//
// RAWGResponseExtensionsTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("RAWGResponse Extensions Tests")
struct RAWGResponseExtensionsTests {
    @Test("currentPage calculates from next URL")
    func currentPageFromNext() throws {
        let response = RAWGResponse(
            count: 100,
            next: "https://api.rawg.io/api/games?page=3&key=test",
            previous: nil,
            results: [Game]()
        )
        
        #expect(response.currentPage == 2)
    }
    
    @Test("currentPage calculates from previous URL")
    func currentPageFromPrevious() throws {
        let response = RAWGResponse(
            count: 100,
            next: nil,
            previous: "https://api.rawg.io/api/games?page=2&key=test",
            results: [Game]()
        )
        
        #expect(response.currentPage == 3)
    }
    
    @Test("currentPage returns nil when no next or previous")
    func currentPageNoPages() throws {
        let response = RAWGResponse(
            count: 5,
            next: nil,
            previous: nil,
            results: [Game]()
        )
        
        #expect(response.currentPage == nil)
    }
    
    @Test("hasPreviousPage returns true when previous exists")
    func hasPreviousPageTrue() throws {
        let response = RAWGResponse(
            count: 100,
            next: nil,
            previous: "https://api.rawg.io/api/games?page=1",
            results: [Game]()
        )
        
        #expect(response.hasPreviousPage == true)
    }
    
    @Test("hasPreviousPage returns false when previous is nil")
    func hasPreviousPageFalse() throws {
        let response = RAWGResponse<Game>(
            count: 100,
            next: "https://api.rawg.io/api/games?page=2",
            previous: nil,
            results: []
        )
        
        #expect(response.hasPreviousPage == false)
    }
    
    @Test("estimatedTotalPages calculates correctly")
    func estimatedTotalPages() throws {
        let games = (1...20).map { id in
            Game(
                id: id,
                name: "Game \(id)",
                slug: "game-\(id)",
                rating: 4.0
            )
        }
        
        let response = RAWGResponse(
            count: 100,
            next: "https://api.rawg.io/api/games?page=2",
            previous: nil,
            results: games
        )
        
        // 100 items, 20 per page = 5 pages
        #expect(response.estimatedTotalPages == 5)
    }
    
    @Test("estimatedTotalPages returns nil when currentPage is nil")
    func estimatedTotalPagesNoCurrentPage() throws {
        let response = RAWGResponse<Game>(
            count: 100,
            next: nil,
            previous: nil,
            results: []
        )
        
        #expect(response.estimatedTotalPages == nil)
    }
    
    @Test("estimatedTotalPages handles partial last page")
    func estimatedTotalPagesPartial() throws {
        let games = (1...20).map { id in
            Game(
                id: id,
                name: "Game \(id)",
                slug: "game-\(id)",
                rating: 4.0
            )
        }
        
        let response = RAWGResponse(
            count: 95,
            next: "https://api.rawg.io/api/games?page=2",
            previous: nil,
            results: games
        )
        
        // 95 items, 20 per page = 5 pages (last page has 15)
        #expect(response.estimatedTotalPages == 5)
    }
    
    @Test("progress calculates correctly for first page")
    func progressFirstPage() throws {
        let games = (1...20).map { id in
            Game(
                id: id,
                name: "Game \(id)",
                slug: "game-\(id)",
                rating: 4.0
            )
        }
        
        let response = RAWGResponse(
            count: 100,
            next: "https://api.rawg.io/api/games?page=2",
            previous: nil,
            results: games
        )
        
        // Page 1: 20/100 = 0.2
        #expect(response.progress == 0.2)
    }
    
    @Test("progress calculates correctly for middle page")
    func progressMiddlePage() throws {
        let games = (1...20).map { id in
            Game(
                id: id,
                name: "Game \(id)",
                slug: "game-\(id)",
                rating: 4.0
            )
        }
        
        let response = RAWGResponse(
            count: 100,
            next: "https://api.rawg.io/api/games?page=4",
            previous: "https://api.rawg.io/api/games?page=2",
            results: games
        )
        
        // Page 3: 60/100 = 0.6
        #expect(response.progress == 0.6)
    }
    
    @Test("progress returns 1.0 for last page")
    func progressLastPage() throws {
        let games = (1...20).map { id in
            Game(
                id: id,
                name: "Game \(id)",
                slug: "game-\(id)",
                rating: 4.0
            )
        }
        
        let response = RAWGResponse(
            count: 100,
            next: nil,
            previous: "https://api.rawg.io/api/games?page=4",
            results: games
        )
        
        // Page 5: 100/100 = 1.0
        #expect(response.progress == 1.0)
    }
    
    @Test("progress returns 1.0 for empty results")
    func progressEmptyResults() throws {
        let response = RAWGResponse<Game>(
            count: 0,
            next: nil,
            previous: nil,
            results: []
        )
        
        #expect(response.progress == 1.0)
    }
}
