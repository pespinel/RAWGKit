//
// RAWGEndpointTests.swift
// RAWGKitTests
//
// Created by RAWGKit Tests on 11/12/2025.
//

@testable import RAWGKit
import Testing

@Suite("RAWGEndpoint Tests")
struct RAWGEndpointTests {
    // MARK: - Games Endpoints

    @Test("games endpoint returns correct path")
    func gamesEndpoint() {
        let endpoint = RAWGEndpoint.games
        #expect(endpoint.path == "/games")
    }

    @Test("game detail endpoint returns correct path")
    func gameDetailEndpoint() {
        let endpoint = RAWGEndpoint.game(id: 3328)
        #expect(endpoint.path == "/games/3328")
    }

    @Test("game screenshots endpoint returns correct path")
    func gameScreenshotsEndpoint() {
        let endpoint = RAWGEndpoint.gameScreenshots(id: 3328)
        #expect(endpoint.path == "/games/3328/screenshots")
    }

    @Test("game movies endpoint returns correct path")
    func gameMoviesEndpoint() {
        let endpoint = RAWGEndpoint.gameMovies(id: 3328)
        #expect(endpoint.path == "/games/3328/movies")
    }

    @Test("game additions endpoint returns correct path")
    func gameAdditionsEndpoint() {
        let endpoint = RAWGEndpoint.gameAdditions(id: 3328)
        #expect(endpoint.path == "/games/3328/additions")
    }

    @Test("game series endpoint returns correct path")
    func gameSeriesEndpoint() {
        let endpoint = RAWGEndpoint.gameSeries(id: 3328)
        #expect(endpoint.path == "/games/3328/game-series")
    }

    @Test("game parent games endpoint returns correct path")
    func gameParentGamesEndpoint() {
        let endpoint = RAWGEndpoint.gameParentGames(id: 3328)
        #expect(endpoint.path == "/games/3328/parent-games")
    }

    @Test("game development team endpoint returns correct path")
    func gameDevelopmentTeamEndpoint() {
        let endpoint = RAWGEndpoint.gameDevelopmentTeam(id: 3328)
        #expect(endpoint.path == "/games/3328/development-team")
    }

    @Test("game stores endpoint returns correct path")
    func gameStoresEndpoint() {
        let endpoint = RAWGEndpoint.gameStores(id: 3328)
        #expect(endpoint.path == "/games/3328/stores")
    }

    @Test("game achievements endpoint returns correct path")
    func gameAchievementsEndpoint() {
        let endpoint = RAWGEndpoint.gameAchievements(id: 3328)
        #expect(endpoint.path == "/games/3328/achievements")
    }

    @Test("game reddit endpoint returns correct path")
    func gameRedditEndpoint() {
        let endpoint = RAWGEndpoint.gameReddit(id: 3328)
        #expect(endpoint.path == "/games/3328/reddit")
    }

    @Test("game twitch endpoint returns correct path")
    func gameTwitchEndpoint() {
        let endpoint = RAWGEndpoint.gameTwitch(id: 3328)
        #expect(endpoint.path == "/games/3328/twitch")
    }

    @Test("game youtube endpoint returns correct path")
    func gameYouTubeEndpoint() {
        let endpoint = RAWGEndpoint.gameYouTube(id: 3328)
        #expect(endpoint.path == "/games/3328/youtube")
    }

    // MARK: - Genre Endpoints

    @Test("genres endpoint returns correct path")
    func genresEndpoint() {
        let endpoint = RAWGEndpoint.genres
        #expect(endpoint.path == "/genres")
    }

    @Test("genre detail endpoint returns correct path")
    func genreDetailEndpoint() {
        let endpoint = RAWGEndpoint.genre(id: 4)
        #expect(endpoint.path == "/genres/4")
    }

    // MARK: - Platform Endpoints

    @Test("platforms endpoint returns correct path")
    func platformsEndpoint() {
        let endpoint = RAWGEndpoint.platforms
        #expect(endpoint.path == "/platforms")
    }

    @Test("platform detail endpoint returns correct path")
    func platformDetailEndpoint() {
        let endpoint = RAWGEndpoint.platform(id: 4)
        #expect(endpoint.path == "/platforms/4")
    }

    @Test("parent platforms endpoint returns correct path")
    func parentPlatformsEndpoint() {
        let endpoint = RAWGEndpoint.parentPlatforms
        #expect(endpoint.path == "/platforms/lists/parents")
    }

    // MARK: - Developer Endpoints

    @Test("developers endpoint returns correct path")
    func developersEndpoint() {
        let endpoint = RAWGEndpoint.developers
        #expect(endpoint.path == "/developers")
    }

    @Test("developer detail endpoint returns correct path")
    func developerDetailEndpoint() {
        let endpoint = RAWGEndpoint.developer(id: 3454)
        #expect(endpoint.path == "/developers/3454")
    }

    // MARK: - Publisher Endpoints

    @Test("publishers endpoint returns correct path")
    func publishersEndpoint() {
        let endpoint = RAWGEndpoint.publishers
        #expect(endpoint.path == "/publishers")
    }

    @Test("publisher detail endpoint returns correct path")
    func publisherDetailEndpoint() {
        let endpoint = RAWGEndpoint.publisher(id: 354)
        #expect(endpoint.path == "/publishers/354")
    }

    // MARK: - Store Endpoints

    @Test("stores endpoint returns correct path")
    func storesEndpoint() {
        let endpoint = RAWGEndpoint.stores
        #expect(endpoint.path == "/stores")
    }

    @Test("store detail endpoint returns correct path")
    func storeDetailEndpoint() {
        let endpoint = RAWGEndpoint.store(id: 1)
        #expect(endpoint.path == "/stores/1")
    }

    // MARK: - Tag Endpoints

    @Test("tags endpoint returns correct path")
    func tagsEndpoint() {
        let endpoint = RAWGEndpoint.tags
        #expect(endpoint.path == "/tags")
    }

    @Test("tag detail endpoint returns correct path")
    func tagDetailEndpoint() {
        let endpoint = RAWGEndpoint.tag(id: 31)
        #expect(endpoint.path == "/tags/31")
    }

    // MARK: - Creator Endpoints

    @Test("creators endpoint returns correct path")
    func creatorsEndpoint() {
        let endpoint = RAWGEndpoint.creators
        #expect(endpoint.path == "/creators")
    }

    @Test("creator detail endpoint returns correct path")
    func creatorDetailEndpoint() {
        let endpoint = RAWGEndpoint.creator(id: "hironobu-sakaguchi")
        #expect(endpoint.path == "/creators/hironobu-sakaguchi")
    }

    @Test("creator roles endpoint returns correct path")
    func creatorRolesEndpoint() {
        let endpoint = RAWGEndpoint.creatorRoles
        #expect(endpoint.path == "/creator-roles")
    }

    // MARK: - Edge Cases

    @Test("game endpoint with zero ID")
    func gameEndpointZeroID() {
        let endpoint = RAWGEndpoint.game(id: 0)
        #expect(endpoint.path == "/games/0")
    }

    @Test("game endpoint with large ID")
    func gameEndpointLargeID() {
        let endpoint = RAWGEndpoint.game(id: 999_999)
        #expect(endpoint.path == "/games/999999")
    }

    @Test("creator endpoint with special characters")
    func creatorEndpointSpecialCharacters() {
        let endpoint = RAWGEndpoint.creator(id: "john-doe-jr")
        #expect(endpoint.path == "/creators/john-doe-jr")
    }

    @Test("creator endpoint with numeric string")
    func creatorEndpointNumericString() {
        let endpoint = RAWGEndpoint.creator(id: "123")
        #expect(endpoint.path == "/creators/123")
    }
}
