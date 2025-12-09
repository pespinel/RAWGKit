# RAWGKit Examples

This directory contains comprehensive examples demonstrating how to use RAWGKit.

## Files

### BasicUsage.swift
Demonstrates fundamental operations:
- Client initialization
- Fetching games and game details
- Searching for games
- Fetching game content (screenshots, videos, achievements)
- Fetching resources (genres, platforms, stores)
- Error handling
- Cache management

### AdvancedQueries.swift
Shows advanced query capabilities:
- Fluent query builder
- Type-safe filtering (platforms, genres, stores)
- Date range filtering
- Metacritic score filtering
- Combining multiple filters
- Exact search
- Various ordering options

### AsyncSequences.swift
Covers AsyncSequence features:
- Streaming large result sets with automatic pagination
- Early termination
- Task cancellation
- Collecting and processing results
- Concurrent operations with async sequences

## Running Examples

All examples require a valid RAWG API key. Get yours at [https://rawg.io/apidocs](https://rawg.io/apidocs).

Replace `"your-api-key"` with your actual API key in any example.

### In a Swift Project

1. Add RAWGKit as a dependency
2. Copy any example file to your project
3. Call the example functions from your code

```swift
import RAWGKit

Task {
    do {
        try await fetchPopularGames()
    } catch {
        print("Error: \(error)")
    }
}
```

### In a Playground

1. Create a new Swift Playground
2. Import RAWGKit
3. Copy and paste any example
4. Run the playground

### With Swift REPL

```bash
swift run --package-path /path/to/RAWGKit
```

## Quick Reference

### Initialize Client
```swift
let client = RAWGClient(apiKey: "your-api-key")
```

### Fetch Games
```swift
let games = try await client.fetchGames(pageSize: 10)
```

### Search Games
```swift
let results = try await client.fetchGames(search: "zelda")
```

### Use Query Builder
```swift
let response = try await client.gamesQuery()
    .search("witcher")
    .orderByRating()
    .year(2015)
    .execute(with: client)
```

### Stream with AsyncSequence
```swift
for try await game in client.allGames(search: "minecraft") {
    print(game.name)
}
```

## More Information

- [Main README](../README.md) - Full documentation
- [Contributing Guide](../CONTRIBUTING.md) - How to contribute
- [API Documentation](https://rawg.io/apidocs) - RAWG API reference
