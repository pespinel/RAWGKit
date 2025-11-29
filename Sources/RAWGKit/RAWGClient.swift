//
// RAWGClient.swift
// RAWGKit
//

import Foundation

/// Main client for interacting with the RAWG API
public actor RAWGClient {
    private let apiKey: String
    private let baseURL: String
    private let networkManager: NetworkManager

    /// Initializes a new RAWG API client
    /// - Parameters:
    ///   - apiKey: Your RAWG API key
    ///   - baseURL: Base URL for the API (default: https://api.rawg.io/api)
    public init(apiKey: String, baseURL: String = "https://api.rawg.io/api") {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.networkManager = NetworkManager()
    }

    // MARK: - Helpers

    private func url(
        for endpoint: RAWGEndpoint,
        queryItems: [String: String]
    ) throws -> URL {
        try networkManager.buildURL(
            baseURL: baseURL,
            path: endpoint.path,
            queryItems: queryItems
        )
    }

    // MARK: - Games

    /// Fetches a list of games with optional filters
    public func fetchGames(
        page: Int = 1,
        pageSize: Int = 20,
        search: String? = nil,
        searchPrecise: Bool? = nil,
        searchExact: Bool? = nil,
        ordering: String? = nil,
        platforms: [Int]? = nil,
        parentPlatforms: [Int]? = nil,
        genres: [Int]? = nil,
        tags: [Int]? = nil,
        developers: String? = nil,
        publishers: String? = nil,
        stores: [Int]? = nil,
        creators: String? = nil,
        dates: String? = nil,
        updated: String? = nil,
        metacritic: String? = nil,
        excludeAdditions: Bool? = nil,
        excludeParents: Bool? = nil,
        excludeGameSeries: Bool? = nil
    ) async throws -> GamesResponse {
        var queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(min(pageSize, 40)),
        ]

        if let search, !search.isEmpty {
            queryItems["search"] = search
        }

        if let searchPrecise {
            queryItems["search_precise"] = String(searchPrecise)
        }

        if let searchExact {
            queryItems["search_exact"] = String(searchExact)
        }

        if let ordering {
            queryItems["ordering"] = ordering
        }

        if let platforms, !platforms.isEmpty {
            queryItems["platforms"] = platforms.map(String.init).joined(separator: ",")
        }

        if let parentPlatforms, !parentPlatforms.isEmpty {
            queryItems["parent_platforms"] = parentPlatforms.map(String.init).joined(separator: ",")
        }

        if let genres, !genres.isEmpty {
            queryItems["genres"] = genres.map(String.init).joined(separator: ",")
        }

        if let tags, !tags.isEmpty {
            queryItems["tags"] = tags.map(String.init).joined(separator: ",")
        }

        if let developers, !developers.isEmpty {
            queryItems["developers"] = developers
        }

        if let publishers, !publishers.isEmpty {
            queryItems["publishers"] = publishers
        }

        if let stores, !stores.isEmpty {
            queryItems["stores"] = stores.map(String.init).joined(separator: ",")
        }

        if let creators, !creators.isEmpty {
            queryItems["creators"] = creators
        }

        if let dates, !dates.isEmpty {
            queryItems["dates"] = dates
        }

        if let updated, !updated.isEmpty {
            queryItems["updated"] = updated
        }

        if let metacritic, !metacritic.isEmpty {
            queryItems["metacritic"] = metacritic
        }

        if let excludeAdditions {
            queryItems["exclude_additions"] = String(excludeAdditions)
        }

        if let excludeParents {
            queryItems["exclude_parents"] = String(excludeParents)
        }

        if let excludeGameSeries {
            queryItems["exclude_game_series"] = String(excludeGameSeries)
        }

        let url = try url(for: .games, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GamesResponse.self)
    }

    /// Fetches detailed information for a specific game
    public func fetchGameDetail(id: Int) async throws -> GameDetail {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .game(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GameDetail.self)
    }

    /// Fetches screenshots for a game
    public func fetchGameScreenshots(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> ScreenshotsResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameScreenshots(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: ScreenshotsResponse.self)
    }

    /// Fetches trailers/movies for a game
    public func fetchGameMovies(id: Int) async throws -> RAWGResponse<Movie> {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .gameMovies(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: RAWGResponse<Movie>.self)
    }

    /// Fetches DLC and editions for a game
    public func fetchGameAdditions(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> GamesResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameAdditions(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GamesResponse.self)
    }

    /// Fetches games in the same series
    public func fetchGameSeries(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> GamesResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameSeries(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GamesResponse.self)
    }

    /// Fetches parent games (for DLC and editions)
    public func fetchGameParentGames(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> GamesResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameParentGames(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GamesResponse.self)
    }

    /// Fetches development team members for a game
    public func fetchGameDevelopmentTeam(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> CreatorsResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameDevelopmentTeam(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: CreatorsResponse.self)
    }

    /// Fetches store links for a game
    public func fetchGameStores(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> GameStoresResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameStores(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GameStoresResponse.self)
    }

    /// Fetches achievements for a game
    public func fetchGameAchievements(id: Int) async throws -> RAWGResponse<Achievement> {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .gameAchievements(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: RAWGResponse<Achievement>.self)
    }

    /// Fetches Reddit posts from the game's subreddit
    public func fetchGameRedditPosts(id: Int) async throws -> RedditPostsResponse {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .gameReddit(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: RedditPostsResponse.self)
    }

    // MARK: - Genres

    /// Fetches a list of game genres
    public func fetchGenres(
        page: Int = 1,
        pageSize: Int = 20,
        ordering: String? = nil
    ) async throws -> GenresResponse {
        var queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]

        if let ordering {
            queryItems["ordering"] = ordering
        }

        let url = try url(for: .genres, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GenresResponse.self)
    }

    /// Fetches details for a specific genre
    public func fetchGenreDetails(id: Int) async throws -> GenreDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .genre(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GenreDetails.self)
    }

    // MARK: - Platforms

    /// Fetches a list of platforms
    public func fetchPlatforms(
        page: Int = 1,
        pageSize: Int = 20,
        ordering: String? = nil
    ) async throws -> PlatformsResponse {
        var queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]

        if let ordering {
            queryItems["ordering"] = ordering
        }

        let url = try url(for: .platforms, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: PlatformsResponse.self)
    }

    /// Fetches details for a specific platform
    public func fetchPlatformDetails(id: Int) async throws -> PlatformDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .platform(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: PlatformDetails.self)
    }

    /// Fetches a list of parent platforms
    public func fetchParentPlatforms(
        page: Int = 1,
        pageSize: Int = 20,
        ordering: String? = nil
    ) async throws -> ParentPlatformsResponse {
        var queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]

        if let ordering {
            queryItems["ordering"] = ordering
        }

        let url = try url(for: .parentPlatforms, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: ParentPlatformsResponse.self)
    }

    // MARK: - Developers

    /// Fetches a list of game developers
    public func fetchDevelopers(
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> DevelopersResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .developers, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: DevelopersResponse.self)
    }

    /// Fetches details for a specific developer
    public func fetchDeveloperDetails(id: Int) async throws -> DeveloperDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .developer(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: DeveloperDetails.self)
    }

    // MARK: - Publishers

    /// Fetches a list of game publishers
    public func fetchPublishers(
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> PublishersResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .publishers, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: PublishersResponse.self)
    }

    /// Fetches details for a specific publisher
    public func fetchPublisherDetails(id: Int) async throws -> PublisherDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .publisher(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: PublisherDetails.self)
    }

    // MARK: - Stores

    /// Fetches a list of game stores
    public func fetchStores(
        page: Int = 1,
        pageSize: Int = 20,
        ordering: String? = nil
    ) async throws -> StoresResponse {
        var queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]

        if let ordering {
            queryItems["ordering"] = ordering
        }

        let url = try url(for: .stores, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: StoresResponse.self)
    }

    /// Fetches details for a specific store
    public func fetchStoreDetails(id: Int) async throws -> StoreDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .store(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: StoreDetails.self)
    }

    // MARK: - Tags

    /// Fetches a list of game tags
    public func fetchTags(
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> TagsResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .tags, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: TagsResponse.self)
    }

    /// Fetches details for a specific tag
    public func fetchTagDetails(id: Int) async throws -> TagDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .tag(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: TagDetails.self)
    }

    // MARK: - Creators

    /// Fetches a list of game creators
    public func fetchCreators(
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> CreatorsResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .creators, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: CreatorsResponse.self)
    }

    /// Fetches details for a specific creator
    public func fetchCreatorDetails(id: String) async throws -> CreatorDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .creator(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: CreatorDetails.self)
    }

    /// Fetches a list of creator roles/positions
    public func fetchCreatorRoles(
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> CreatorRolesResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .creatorRoles, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: CreatorRolesResponse.self)
    }
}
