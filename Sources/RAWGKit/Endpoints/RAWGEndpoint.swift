//
// RAWGEndpoint.swift
// RAWGKit
//

enum RAWGEndpoint {
    case games
    case game(id: Int)
    case gameScreenshots(id: Int)
    case gameMovies(id: Int)
    case gameAdditions(id: Int)
    case gameSeries(id: Int)
    case gameParentGames(id: Int)
    case gameDevelopmentTeam(id: Int)
    case gameStores(id: Int)
    case gameAchievements(id: Int)
    case gameReddit(id: Int)
    case gameTwitch(id: Int)
    case gameYouTube(id: Int)
    case genres
    case genre(id: Int)
    case platforms
    case platform(id: Int)
    case parentPlatforms
    case developers
    case developer(id: Int)
    case publishers
    case publisher(id: Int)
    case stores
    case store(id: Int)
    case tags
    case tag(id: Int)
    case creators
    case creator(id: String)
    case creatorRoles

    var path: String {
        switch self {
        case .games: "/games"
        case let .game(id): "/games/\(id)"
        case let .gameScreenshots(id): "/games/\(id)/screenshots"
        case let .gameMovies(id): "/games/\(id)/movies"
        case let .gameAdditions(id): "/games/\(id)/additions"
        case let .gameSeries(id): "/games/\(id)/game-series"
        case let .gameParentGames(id): "/games/\(id)/parent-games"
        case let .gameDevelopmentTeam(id): "/games/\(id)/development-team"
        case let .gameStores(id): "/games/\(id)/stores"
        case let .gameAchievements(id): "/games/\(id)/achievements"
        case let .gameReddit(id): "/games/\(id)/reddit"
        case let .gameTwitch(id): "/games/\(id)/twitch"
        case let .gameYouTube(id): "/games/\(id)/youtube"
        case .genres: "/genres"
        case let .genre(id): "/genres/\(id)"
        case .platforms: "/platforms"
        case let .platform(id): "/platforms/\(id)"
        case .parentPlatforms: "/platforms/lists/parents"
        case .developers: "/developers"
        case let .developer(id): "/developers/\(id)"
        case .publishers: "/publishers"
        case let .publisher(id): "/publishers/\(id)"
        case .stores: "/stores"
        case let .store(id): "/stores/\(id)"
        case .tags: "/tags"
        case let .tag(id): "/tags/\(id)"
        case .creators: "/creators"
        case let .creator(id): "/creators/\(id)"
        case .creatorRoles: "/creator-roles"
        }
    }
}
