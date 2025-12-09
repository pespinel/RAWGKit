import Foundation
import RAWGKit

// MARK: - Advanced Query Examples

/// Using the fluent query builder
func fluentQueryBuilder() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Complex query with multiple filters
    let response = try await client.gamesQuery()
        .search("witcher")
        .orderByRating()
        .year(2015)
        .platforms([.pc, .playStation4, .xboxOne])
        .genres([.rpg, .action])
        .metacriticMin(80)
        .pageSize(20)
        .execute(with: client)

    print("Found \(response.count) games matching criteria")
}

/// Type-safe platform filtering
func platformFiltering() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Filter by specific platforms
    let response = try await client.gamesQuery()
        .platforms([.playStation5, .xboxSeriesX, .pc])
        .orderByReleased()
        .pageSize(10)
        .execute(with: client)

    print("Latest games for next-gen consoles:")
    for game in response.results {
        print("- \(game.name)")
    }
}

/// Genre-based filtering
func genreFiltering() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Find RPG games
    let response = try await client.gamesQuery()
        .genres([.rpg])
        .orderByRating()
        .metacritic(min: 85, max: 100)
        .pageSize(10)
        .execute(with: client)

    print("Top-rated RPG games:")
    for game in response.results {
        print("- \(game.name) (Metacritic: \(game.metacritic ?? 0))")
    }
}

/// Date range filtering
func dateRangeFiltering() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Games released this year
    let thisYear = try await client.gamesQuery()
        .releasedThisYear()
        .orderByReleased()
        .execute(with: client)

    print("Games released this year: \(thisYear.count)")

    // Games from specific date range
    let calendar = Calendar.current
    let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1))!
    let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!

    let rangeGames = try await client.gamesQuery()
        .releasedBetween(from: startDate, to: endDate)
        .orderByRating()
        .execute(with: client)

    print("Games from 2020-2023: \(rangeGames.count)")

    // Games from last 30 days
    let recentGames = try await client.gamesQuery()
        .releasedInLast(days: 30)
        .orderByAdded()
        .execute(with: client)

    print("Games from last 30 days: \(recentGames.count)")
}

/// Metacritic score filtering
func metacriticFiltering() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Highly rated games
    let response = try await client.gamesQuery()
        .metacritic(min: 90, max: 100)
        .orderByMetacriticDescending()
        .pageSize(20)
        .execute(with: client)

    print("Games with 90+ Metacritic:")
    for game in response.results {
        print("- \(game.name): \(game.metacritic ?? 0)")
    }
}

/// Store filtering
func storeFiltering() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Games available on Steam
    let response = try await client.gamesQuery()
        .stores([.steam])
        .orderByRating()
        .pageSize(10)
        .execute(with: client)

    print("Top games on Steam:")
    for game in response.results {
        print("- \(game.name)")
    }
}

/// Combining multiple filters
func complexFiltering() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Find the best action RPGs on PC from last year
    let calendar = Calendar.current
    let lastYear = calendar.component(.year, from: Date()) - 1

    let response = try await client.gamesQuery()
        .genres([.action, .rpg])
        .platforms([.pc])
        .year(lastYear)
        .metacriticMin(80)
        .orderByMetacriticDescending()
        .pageSize(10)
        .execute(with: client)

    print("Best action RPGs on PC from \(lastYear):")
    for game in response.results {
        let platforms = game.platforms?.map(\.platform.name).joined(separator: ", ") ?? "Unknown"
        print("- \(game.name)")
        print("  Rating: \(game.rating), Metacritic: \(game.metacritic ?? 0)")
        print("  Platforms: \(platforms)")
    }
}

/// Exact search
func exactSearch() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Find exact match
    let response = try await client.gamesQuery()
        .search("The Witcher 3")
        .searchExact()
        .execute(with: client)

    if let game = response.results.first {
        print("Found: \(game.name)")
    }
}

/// Ordering examples
func orderingExamples() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // By rating (descending)
    let byRating = try await client.gamesQuery()
        .orderByRating()
        .pageSize(5)
        .execute(with: client)

    // By release date (newest first)
    let byRelease = try await client.gamesQuery()
        .orderByReleased()
        .pageSize(5)
        .execute(with: client)

    // By metacritic score
    let byMetacritic = try await client.gamesQuery()
        .orderByMetacriticDescending()
        .pageSize(5)
        .execute(with: client)

    // By date added to database
    let byAdded = try await client.gamesQuery()
        .orderByAdded()
        .pageSize(5)
        .execute(with: client)

    print("Ordered by rating: \(byRating.results.count)")
    print("Ordered by release: \(byRelease.results.count)")
    print("Ordered by metacritic: \(byMetacritic.results.count)")
    print("Ordered by added: \(byAdded.results.count)")
}
