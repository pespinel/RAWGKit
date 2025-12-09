import RAWGKit

// MARK: - Basic Usage Examples

/// Initialize the client
func initializeClient() {
    let client = RAWGClient(apiKey: "your-api-key")

    // With caching disabled
    let clientNoCache = RAWGClient(apiKey: "your-api-key", cacheEnabled: false)
}

/// Fetch popular games
func fetchPopularGames() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Get top 10 games by rating
    let response = try await client.fetchGames(
        pageSize: 10,
        ordering: "-rating"
    )

    print("Found \(response.count) games")

    for game in response.results {
        print("\(game.name) - Rating: \(game.rating)")
    }
}

/// Get game details
func fetchGameDetails() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Get GTA V details
    let game = try await client.fetchGameDetail(id: 3498)

    print("Name: \(game.name)")
    print("Released: \(game.released ?? "Unknown")")
    print("Rating: \(game.rating)")
    print("Metacritic: \(game.metacritic ?? 0)")
    print("Description: \(game.description ?? "No description")")
}

/// Search for games
func searchGames() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Search for Zelda games
    let response = try await client.fetchGames(
        search: "zelda",
        pageSize: 5,
        ordering: "-rating"
    )

    print("Found \(response.results.count) Zelda games:")
    for game in response.results {
        print("- \(game.name)")
    }
}

/// Fetch game content
func fetchGameContent() async throws {
    let client = RAWGClient(apiKey: "your-api-key")
    let gameId = 3498 // GTA V

    // Get screenshots
    let screenshots = try await client.fetchGameScreenshots(id: gameId)
    print("Screenshots: \(screenshots.count)")

    // Get trailers
    let movies = try await client.fetchGameMovies(id: gameId)
    print("Trailers: \(movies.count)")

    // Get achievements
    let achievements = try await client.fetchGameAchievements(id: gameId)
    print("Achievements: \(achievements.count)")
}

/// Fetch resources
func fetchResources() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Get all genres
    let genres = try await client.fetchGenres()
    print("Genres:")
    for genre in genres.results {
        print("- \(genre.name): \(genre.gamesCount ?? 0) games")
    }

    // Get all platforms
    let platforms = try await client.fetchPlatforms()
    print("\nPlatforms:")
    for platform in platforms.results {
        print("- \(platform.name)")
    }

    // Get all stores
    let stores = try await client.fetchStores()
    print("\nStores:")
    for store in stores.results {
        print("- \(store.name)")
    }
}

/// Error handling
func errorHandling() async {
    let client = RAWGClient(apiKey: "invalid-key")

    do {
        let response = try await client.fetchGames()
        print("Success: \(response.count) games")
    } catch NetworkError.unauthorized {
        print("Error: Invalid API key")
    } catch let NetworkError.rateLimitExceeded(message) {
        print("Error: Rate limit exceeded - \(message)")
    } catch NetworkError.notFound {
        print("Error: Resource not found")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/// Cache management
func cacheManagement() async {
    let client = RAWGClient(apiKey: "your-api-key")

    // Get cache statistics
    let stats = await client.cacheStats()
    print("Cache entries: \(stats.totalEntries)")
    print("Cache hits: \(stats.hits)")
    print("Cache misses: \(stats.misses)")
    print("Hit rate: \(stats.hitRate)%")

    // Clear cache
    await client.clearCache()
    print("Cache cleared")
}
