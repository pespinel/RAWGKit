//
// GamesViewModelTests.swift
// RAWGKitTests
//
// Created by RAWGKit Tests on 11/12/2025.
//

import Foundation
@testable import RAWGKit
import Testing

@MainActor
@Suite("GamesViewModel Tests")
struct GamesViewModelTests {
    let client: RAWGClient?

    init() {
        // Get API key from environment variable
        if let apiKey = ProcessInfo.processInfo.environment["RAWG_API_KEY"], !apiKey.isEmpty {
            client = RAWGClient(apiKey: apiKey)
        } else {
            client = nil
        }
    }

    // MARK: - Initialization Tests

    @Test(
        "GamesViewModel initializes with idle state",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func initialization() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        #expect(viewModel.state == .idle)
        #expect(viewModel.games.isEmpty)
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.platformIDs.isEmpty)
        #expect(viewModel.genreIDs.isEmpty)
        #expect(viewModel.ordering == nil)
        #expect(viewModel.canLoadMore == true)
    }

    // MARK: - Loading Tests

    @Test(
        "loadGames loads first page successfully",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func loadGamesSuccess() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        await viewModel.loadGames()

        #expect(viewModel.state == .loaded)
        #expect(viewModel.games.isEmpty == false)
    }

    @Test(
        "loadGames resets pagination",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func loadGamesResetsPagination() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        // Load first page
        await viewModel.loadGames()
        let firstPageCount = viewModel.games.count
        #expect(firstPageCount > 0)

        // Load more
        viewModel.loadMore()
        try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
        let afterLoadMoreCount = viewModel.games.count
        #expect(afterLoadMoreCount >= firstPageCount)

        // Reload should reset
        await viewModel.loadGames()
        #expect(viewModel.games.count == firstPageCount)
    }

    // MARK: - Pagination Tests

    @Test(
        "loadMore loads next page",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func testLoadMore() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        await viewModel.loadGames()
        let firstPageCount = viewModel.games.count

        viewModel.loadMore()
        try? await Task.sleep(nanoseconds: 500_000_000) // 500ms

        #expect(viewModel.games.count > firstPageCount)
    }

    // MARK: - Search Tests

    @Test(
        "searchQuery triggers reload with debounce",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func searchQueryDebounce() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        await viewModel.loadGames()
        let initialGames = viewModel.games

        viewModel.searchQuery = "zelda"

        // Wait for debounce (300ms)
        try? await Task.sleep(nanoseconds: 400_000_000) // 400ms

        // Should have reloaded with different games
        #expect(viewModel.games != initialGames)
    }

    // MARK: - Filter Tests

    @Test(
        "platformIDs triggers reload",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func platformIDsReload() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        await viewModel.loadGames()
        let initialGames = viewModel.games

        viewModel.platformIDs = [4] // PC
        try? await Task.sleep(nanoseconds: 200_000_000)

        #expect(viewModel.games != initialGames)
    }

    @Test(
        "genreIDs triggers reload",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func genreIDsReload() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        await viewModel.loadGames()
        let initialGames = viewModel.games

        viewModel.genreIDs = [4] // Action
        try? await Task.sleep(nanoseconds: 200_000_000)

        #expect(viewModel.games != initialGames)
    }

    @Test(
        "ordering triggers reload",
        .enabled(if: ProcessInfo.processInfo.environment["RAWG_API_KEY"] != nil)
    )
    func orderingReload() async throws {
        guard let client else {
            throw SkipError()
        }

        let viewModel = GamesViewModel(client: client)

        await viewModel.loadGames()
        let initialGames = viewModel.games

        viewModel.ordering = "-rating"
        try? await Task.sleep(nanoseconds: 200_000_000)

        #expect(viewModel.games != initialGames)
    }

    // MARK: - State Equality Tests

    @Test("State equality works correctly")
    func stateEquality() async throws {
        #expect(GamesViewModel.State.idle == .idle)
        #expect(GamesViewModel.State.loading == .loading)
        #expect(GamesViewModel.State.loaded == .loaded)

        let error1 = NetworkError.invalidResponse
        let error2 = NetworkError.invalidResponse
        #expect(GamesViewModel.State.error(error1) == .error(error2))

        #expect(GamesViewModel.State.idle != .loading)
        #expect(GamesViewModel.State.loading != .loaded)
    }
}
