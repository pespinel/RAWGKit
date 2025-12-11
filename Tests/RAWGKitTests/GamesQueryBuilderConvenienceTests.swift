@testable import RAWGKit
import Testing

@Suite("GamesQueryBuilder Convenience Tests")
struct GamesQueryBuilderConvenienceTests {
    // MARK: - Platform.Popular Extensions

    @Test("Query builder accepts Platform.Popular constants")
    func platformPopularIntegration() {
        _ = GamesQueryBuilder()
            .platformsPopular([Platform.Popular.pc, Platform.Popular.playStation5])
    }

    @Test("Query builder accepts single Platform.Popular constant")
    func singlePlatformPopular() {
        _ = GamesQueryBuilder()
            .platformsPopular([Platform.Popular.nintendoSwitch])
    }

    // MARK: - Genre.Popular Extensions

    @Test("Query builder accepts Genre.Popular constants")
    func genrePopularIntegration() {
        _ = GamesQueryBuilder()
            .genresPopular([Genre.Popular.action, Genre.Popular.rpg])
    }

    @Test("Query builder accepts single Genre.Popular constant")
    func singleGenrePopular() {
        _ = GamesQueryBuilder()
            .genresPopular([Genre.Popular.indie])
    }

    // MARK: - Convenience Query Methods

    @Test("popularGames() creates valid query")
    func popularGamesQuery() {
        _ = GamesQueryBuilder.popularGames()
    }

    @Test("newReleases() creates valid query")
    func newReleasesQuery() {
        _ = GamesQueryBuilder.newReleases()
    }

    @Test("upcomingGames() creates valid query")
    func upcomingGamesQuery() {
        _ = GamesQueryBuilder.upcomingGames()
    }

    @Test("topRated() creates valid query")
    func topRatedQuery() {
        _ = GamesQueryBuilder.topRated()
    }

    @Test("thisYear() creates valid query")
    func thisYearQuery() {
        _ = GamesQueryBuilder.thisYear()
    }

    @Test("trending() creates valid query")
    func trendingQuery() {
        _ = GamesQueryBuilder.trending()
    }

    // MARK: - Chaining with Convenience Methods

    @Test("Can chain Platform.Popular with other filters")
    func chainingPlatformPopular() {
        _ = GamesQueryBuilder()
            .platformsPopular([Platform.Popular.pc])
            .genresPopular([Genre.Popular.action])
            .metacriticMin(80)
            .search("cyberpunk")
    }

    @Test("Can chain Genre.Popular with other filters")
    func chainingGenrePopular() {
        _ = GamesQueryBuilder()
            .genresPopular([Genre.Popular.rpg, Genre.Popular.strategy])
            .platformsPopular([Platform.Popular.pc, Platform.Popular.macOS])
            .orderByRating()
    }

    @Test("Can modify convenience queries")
    func modifyingConvenienceQuery() {
        _ = GamesQueryBuilder.popularGames()
            .platformsPopular([Platform.Popular.playStation5])
            .pageSize(20)
    }

    // MARK: - Complex Queries

    @Test("Complex query with Platform.Popular and Genre.Popular")
    func complexQueryWithPopular() {
        _ = GamesQueryBuilder()
            .platformsPopular([
                Platform.Popular.pc,
                Platform.Popular.playStation5,
                Platform.Popular.xboxSeriesXS,
            ])
            .genresPopular([
                Genre.Popular.action,
                Genre.Popular.adventure,
                Genre.Popular.rpg,
            ])
            .metacriticMin(85)
            .releasedInLast(days: 365)
            .orderByMetacritic()
            .pageSize(30)
    }

    @Test("Convenience queries can be chained")
    func convenienceChaining() {
        _ = GamesQueryBuilder.popularGames()
            .platformsPopular([Platform.Popular.pc])
            .pageSize(20)

        _ = GamesQueryBuilder.newReleases()
            .genresPopular([Genre.Popular.action, Genre.Popular.shooter])

        _ = GamesQueryBuilder.topRated()
            .platformsPopular([Platform.Popular.playStation5, Platform.Popular.xboxSeriesXS])
            .genresPopular([Genre.Popular.rpg])
    }
}
