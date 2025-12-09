import RAWGKit

// MARK: - AsyncSequence Examples

/// Stream all games with automatic pagination
func streamAllGames() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Iterate through all Zelda games
    var count = 0
    for try await game in client.allGames(search: "zelda") {
        print("\(count + 1). \(game.name)")
        count += 1

        // Process first 50 results
        if count >= 50 {
            break
        }
    }

    print("Processed \(count) games")
}

/// Stream all genres
func streamGenres() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("All genres:")
    for try await genre in client.allGenres() {
        print("- \(genre.name): \(genre.gamesCount ?? 0) games")
    }
}

/// Stream all platforms
func streamPlatforms() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("All platforms:")
    for try await platform in client.allPlatforms() {
        let yearInfo = platform.yearStart != nil ? " (\(platform.yearStart!))" : ""
        print("- \(platform.name)\(yearInfo)")
    }
}

/// Stream developers
func streamDevelopers() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("Top developers:")
    var count = 0
    for try await developer in client.allDevelopers() {
        print("- \(developer.name): \(developer.gamesCount ?? 0) games")
        count += 1

        if count >= 20 {
            break
        }
    }
}

/// Stream publishers
func streamPublishers() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("Top publishers:")
    var count = 0
    for try await publisher in client.allPublishers() {
        print("- \(publisher.name): \(publisher.gamesCount ?? 0) games")
        count += 1

        if count >= 20 {
            break
        }
    }
}

/// Stream stores
func streamStores() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("All stores:")
    for try await store in client.allStores() {
        let domain = store.domain ?? "N/A"
        print("- \(store.name): \(domain)")
    }
}

/// Stream tags
func streamTags() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("Popular tags:")
    var count = 0
    for try await tag in client.allTags() {
        print("- \(tag.name): \(tag.gamesCount ?? 0) games")
        count += 1

        if count >= 30 {
            break
        }
    }
}

/// Stream creators
func streamCreators() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    print("Game creators:")
    var count = 0
    for try await creator in client.allCreators() {
        print("- \(creator.name): \(creator.gamesCount ?? 0) games")
        count += 1

        if count >= 20 {
            break
        }
    }
}

/// Early termination example
func earlyTermination() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Find first game with rating > 4.5
    for try await game in client.allGames(ordering: "-rating") {
        if game.rating > 4.5 {
            print("Found highly rated game: \(game.name) (\(game.rating))")
            break // Stops pagination automatically
        }
    }
}

/// Filtering with async sequences
func filteringWithSequences() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Find all RPG games with rating > 4.0
    var rpgGames: [String] = []

    for try await game in client.allGames(genres: "role-playing-games-rpg") {
        if game.rating > 4.0 {
            rpgGames.append(game.name)
        }

        // Limit to 50 results
        if rpgGames.count >= 50 {
            break
        }
    }

    print("High-rated RPGs:")
    for name in rpgGames {
        print("- \(name)")
    }
}

/// Task cancellation example
func cancellationExample() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    let task = Task {
        var count = 0
        for try await game in client.allGames() {
            print("Processing: \(game.name)")
            count += 1

            // Check for cancellation
            if Task.isCancelled {
                print("Task was cancelled")
                break
            }
        }
        return count
    }

    // Cancel after a delay
    try await Task.sleep(for: .seconds(2))
    task.cancel()

    let processedCount = try await task.value
    print("Processed \(processedCount) games before cancellation")
}

/// Collecting results from sequence
func collectResults() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Collect all genres into an array
    var genres: [Genre] = []
    for try await genre in client.allGenres() {
        genres.append(genre)
    }

    print("Collected \(genres.count) genres")

    // Sort by game count
    let sortedGenres = genres.sorted { ($0.gamesCount ?? 0) > ($1.gamesCount ?? 0) }
    print("\nTop 5 genres by game count:")
    for genre in sortedGenres.prefix(5) {
        print("- \(genre.name): \(genre.gamesCount ?? 0) games")
    }
}

/// Using async/await with map
func asyncMap() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Get first 10 games and fetch their details
    var gameIds: [Int] = []
    var count = 0

    for try await game in client.allGames(pageSize: 10) {
        gameIds.append(game.id)
        count += 1
        if count >= 10 {
            break
        }
    }

    // Fetch details for each game
    print("Fetching details for \(gameIds.count) games...")
    for id in gameIds {
        let details = try await client.fetchGameDetail(id: id)
        print("- \(details.name): \(details.playtime ?? 0) hours avg playtime")
    }
}

/// Concurrent processing with sequences
func concurrentProcessing() async throws {
    let client = RAWGClient(apiKey: "your-api-key")

    // Collect genre IDs
    var genreIds: [Int] = []
    var count = 0
    for try await genre in client.allGenres() {
        genreIds.append(genre.id)
        count += 1
        if count >= 5 {
            break
        }
    }

    // Fetch details concurrently
    await withTaskGroup(of: (String, String).self) { group in
        for id in genreIds {
            group.addTask {
                let details = try await client.fetchGenreDetails(id: id)
                return (details.name, details.description ?? "No description")
            }
        }

        for await (name, description) in group {
            print("\(name):")
            print(description.prefix(100))
            print("---")
        }
    }
}
