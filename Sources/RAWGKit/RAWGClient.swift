//
// RAWGClient.swift
// RAWGKit
//
// swiftlint:disable file_length

import Foundation

/// Type alias for cache statistics returned by the client.
public typealias CacheStats = CacheManager.CacheStats

/// Main client for interacting with the RAWG Video Games Database API.
///
/// `RAWGClient` provides a comprehensive Swift interface to the RAWG API,
/// offering methods to fetch games, platforms, genres, developers, and more.
///
/// ## Features
/// - **Type-safe queries**: Strongly-typed models for all API responses
/// - **Automatic caching**: Built-in HTTP caching with TTL support
/// - **Request deduplication**: Prevents duplicate simultaneous requests
/// - **Pagination support**: AsyncSequence-based streaming for large datasets
/// - **Query builder**: Fluent API for complex game queries
/// - **Actor-based**: Thread-safe concurrent API access
///
/// ## Usage
/// ```swift
/// let client = RAWGClient(apiKey: "your-api-key")
///
/// // Fetch games
/// let games = try await client.fetchGames(search: "Witcher")
///
/// // Get game details
/// let game = try await client.fetchGameDetail(id: 3328)
///
/// // Stream all RPG games
/// for try await game in client.gamesSequence(genres: [5]) {
///     print(game.name)
/// }
/// ```
///
/// - Note: All methods are `async throws` and should be called within an async context.
/// - Important: Requires a valid RAWG API key. Get one at https://rawg.io/apidocs
public actor RAWGClient {
    /// Your RAWG API key for authentication.
    private let apiKey: String

    /// Base URL for the RAWG API.
    private let baseURL: String

    /// Network manager handling HTTP requests and caching.
    private let networkManager: NetworkManager

    /// Creates a new RAWG API client.
    ///
    /// - Parameters:
    ///   - apiKey: Your RAWG API key. Required for all API requests.
    ///   - baseURL: Base URL for the API. Defaults to the official RAWG API endpoint.
    ///   - cacheEnabled: Whether to enable HTTP response caching. Defaults to `true`.
    ///
    /// - Important: Keep your API key secure and never commit it to version control.
    public init(apiKey: String, baseURL: String = "https://api.rawg.io/api", cacheEnabled: Bool = true) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.networkManager = NetworkManager(cacheEnabled: cacheEnabled)
    }

    // MARK: - Cache Control

    /// Clears all cached API responses.
    ///
    /// Use this to free memory or force fresh data on the next requests.
    public func clearCache() async {
        await networkManager.clearCache()
    }

    /// Retrieves cache statistics.
    ///
    /// Provides insights into cache usage, including total entries,
    /// valid entries, and expired entries.
    ///
    /// - Returns: A `CacheStats` structure with cache metrics.
    public func cacheStats() async -> CacheStats {
        await networkManager.cacheStats()
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

    /// Fetches a paginated list of games with extensive filtering options.
    ///
    /// This is the primary method for searching and browsing games. It supports
    /// a wide range of filters including search queries, platforms, genres, stores,
    /// date ranges, and Metacritic scores.
    ///
    /// For a more fluent and type-safe approach to building complex queries,
    /// consider using `GamesQueryBuilder` instead.
    ///
    /// - Parameters:
    ///   - page: Page number to fetch (1-indexed). Defaults to 1.
    ///   - pageSize: Number of results per page (max 40). Defaults to 20.
    ///   - search: Search query for game titles.
    ///   - searchPrecise: Whether to use precise search matching.
    ///   - searchExact: Whether to use exact search matching.
    ///   - ordering: Sort order (e.g., "-rating", "name", "-released").
    ///   - platforms: Filter by platform IDs.
    ///   - parentPlatforms: Filter by parent platform IDs.
    ///   - genres: Filter by genre IDs.
    ///   - tags: Filter by tag IDs.
    ///   - developers: Filter by developer slug(s), comma-separated.
    ///   - publishers: Filter by publisher slug(s), comma-separated.
    ///   - stores: Filter by store IDs.
    ///   - creators: Filter by creator slug(s), comma-separated.
    ///   - dates: Date range filter (e.g., "2020-01-01,2020-12-31").
    ///   - updated: Last update date filter.
    ///   - metacritic: Metacritic score filter (e.g., "80,100").
    ///   - excludeAdditions: Whether to exclude DLCs and additions.
    ///   - excludeParents: Whether to exclude parent games in a series.
    ///   - excludeGameSeries: Whether to exclude game series entries.
    ///
    /// - Returns: A `GamesResponse` containing paginated game results.
    /// - Throws: `NetworkError` if the request fails.
    ///
    /// ## Example
    /// ```swift
    /// // Search for RPG games on PlayStation
    /// let games = try await client.fetchGames(
    ///     search: "RPG",
    ///     platforms: [187], // PlayStation 5
    ///     genres: [5], // RPG
    ///     ordering: "-rating"
    /// )
    /// ```
    public func fetchGames(
        page: Int = RAWGConstants.minPage,
        pageSize: Int = RAWGConstants.defaultPageSize,
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
            "page_size": String(min(pageSize, RAWGConstants.maxPageSize)),
        ]
        if let search, !search.isEmpty { queryItems["search"] = search }
        if let searchPrecise { queryItems["search_precise"] = String(searchPrecise) }
        if let searchExact { queryItems["search_exact"] = String(searchExact) }
        if let ordering { queryItems["ordering"] = ordering }
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
        if let developers, !developers.isEmpty { queryItems["developers"] = developers }
        if let publishers, !publishers.isEmpty { queryItems["publishers"] = publishers }
        if let stores, !stores.isEmpty {
            queryItems["stores"] = stores.map(String.init).joined(separator: ",")
        }
        if let creators, !creators.isEmpty { queryItems["creators"] = creators }
        if let dates, !dates.isEmpty { queryItems["dates"] = dates }
        if let updated, !updated.isEmpty { queryItems["updated"] = updated }
        if let metacritic, !metacritic.isEmpty { queryItems["metacritic"] = metacritic }
        if let excludeAdditions { queryItems["exclude_additions"] = String(excludeAdditions) }
        if let excludeParents { queryItems["exclude_parents"] = String(excludeParents) }
        if let excludeGameSeries { queryItems["exclude_game_series"] = String(excludeGameSeries) }

        let url = try url(for: .games, queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GamesResponse.self)
    }

    /// Fetches comprehensive game details including description, ratings, and metadata
    public func fetchGameDetail(id: Int) async throws -> GameDetail {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .game(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GameDetail.self)
    }

    /// Fetches official screenshots for a game in multiple resolutions
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

    /// Fetches trailers and gameplay videos for a game
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

    /// Fetches stores where a game can be purchased with links
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

    /// Fetches Twitch streams for a game
    public func fetchGameTwitchStreams(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> TwitchStreamsResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameTwitch(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: TwitchStreamsResponse.self)
    }

    /// Fetches YouTube videos for a game
    public func fetchGameYouTubeVideos(
        id: Int,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> YouTubeVideosResponse {
        let queryItems: [String: String] = [
            "key": apiKey,
            "page": String(page),
            "page_size": String(pageSize),
        ]
        let url = try url(for: .gameYouTube(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: YouTubeVideosResponse.self)
    }

    // MARK: - Genres

    /// Fetches all game genres with metadata and game counts
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

    /// Fetches detailed information for a specific genre by ID
    public func fetchGenreDetails(id: Int) async throws -> GenreDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .genre(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: GenreDetails.self)
    }

    // MARK: - Platforms

    /// Fetches all gaming platforms (consoles, PC, mobile) with metadata
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

    /// Fetches detailed information for a specific platform by ID
    public func fetchPlatformDetails(id: Int) async throws -> PlatformDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .platform(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: PlatformDetails.self)
    }

    /// Fetches a list of parent platforms (e.g., PlayStation, Xbox, PC)
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

    /// Fetches a paginated list of game developers
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

    /// Fetches detailed information for a specific developer by ID
    public func fetchDeveloperDetails(id: Int) async throws -> DeveloperDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .developer(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: DeveloperDetails.self)
    }

    // MARK: - Publishers

    /// Fetches a paginated list of game publishers
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

    /// Fetches detailed information for a specific publisher by ID
    public func fetchPublisherDetails(id: Int) async throws -> PublisherDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .publisher(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: PublisherDetails.self)
    }

    // MARK: - Stores

    /// Fetches digital and physical stores (Steam, PlayStation Store, etc.)
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

    /// Fetches detailed information for a specific store by ID
    public func fetchStoreDetails(id: Int) async throws -> StoreDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .store(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: StoreDetails.self)
    }

    // MARK: - Tags

    /// Fetches a paginated list of game tags
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

    /// Fetches detailed information for a specific tag by ID
    public func fetchTagDetails(id: Int) async throws -> TagDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .tag(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: TagDetails.self)
    }

    // MARK: - Creators

    /// Fetches game creators, designers, and developers
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

    /// Fetches detailed information for a specific creator by ID
    public func fetchCreatorDetails(id: String) async throws -> CreatorDetails {
        let queryItems: [String: String] = ["key": apiKey]
        let url = try url(for: .creator(id: id), queryItems: queryItems)
        return try await networkManager.fetch(from: url, as: CreatorDetails.self)
    }

    /// Fetches a paginated list of creator roles and positions
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
