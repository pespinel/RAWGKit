# Advanced Features

Master complex queries, pagination, and advanced RAWGKit capabilities.

## Overview

This guide covers advanced RAWGKit features including the query builder, AsyncSequence pagination, caching strategies, and custom network configurations.

## Query Builder

The ``GamesQueryBuilder`` provides a fluent, type-safe API for constructing complex game queries.

### Basic Query Building

```swift
import RAWGKit

let response = try await client.gamesQuery()
    .search("witcher")
    .orderByRating()
    .year(2015)
    .pageSize(20)
    .execute(with: client)

print("Found \(response.count) games")
```

### Type-Safe Filters

Use enums instead of magic numbers for platforms, genres, and stores:

```swift
// Platforms
let query = client.gamesQuery()
    .platforms([.pc, .playStation5, .xboxSeriesX, .nintendoSwitch])

// Parent platforms (groups)
let consoleQuery = client.gamesQuery()
    .parentPlatforms([.playStation, .xbox, .nintendo])

// Genres
let rpgQuery = client.gamesQuery()
    .genres([.rpg, .action, .adventure])

// Stores
let storeQuery = client.gamesQuery()
    .stores([.steam, .epicGames, .playStationStore])

// Ordering
let sortedQuery = client.gamesQuery()
    .ordering(.metacriticDescending)
```

### Date Filtering

Filter games by release date using convenient date helpers:

```swift
// Games from this year
let thisYear = try await client.gamesQuery()
    .releasedThisYear()
    .execute(with: client)

// Games from last 30 days
let recent = try await client.gamesQuery()
    .releasedInLast(days: 30)
    .execute(with: client)

// Games in a date range
let dateRange = try await client.gamesQuery()
    .releasedBetween(
        from: Date(timeIntervalSince1970: 1609459200), // Jan 1, 2021
        to: Date(timeIntervalSince1970: 1640995200)    // Jan 1, 2022
    )
    .execute(with: client)

// Games released after a date
let afterDate = try await client.gamesQuery()
    .releasedAfter(someDate)
    .execute(with: client)

// Games released before a date
let beforeDate = try await client.gamesQuery()
    .releasedBefore(someDate)
    .execute(with: client)
```

### Metacritic Scores

Filter by Metacritic score ranges:

```swift
// Highly rated games (80+)
let highlyRated = try await client.gamesQuery()
    .metacritic(min: 80, max: 100)
    .execute(with: client)

// Minimum score only
let decentGames = try await client.gamesQuery()
    .metacriticMin(70)
    .execute(with: client)
```

### Complex Queries

Combine multiple filters for precise results:

```swift
let query = try await client.gamesQuery()
    .search("cyberpunk")
    .searchExact() // Exact match
    .platforms([.pc, .playStation5])
    .genres([.rpg, .action])
    .releasedBetween(
        from: Date(timeIntervalSince1970: 1577836800), // 2020
        to: Date(timeIntervalSince1970: 1609459200)    // 2021
    )
    .metacritic(min: 75, max: 100)
    .orderByMetacriticDescending()
    .pageSize(20)
    .execute(with: client)

print("Found \(query.count) matching games")
```

## AsyncSequence Pagination

Stream large result sets efficiently using AsyncSequence:

### Games Sequence

```swift
// Iterate through all games matching a query
for try await game in await client.gamesSequence(
    search: "zelda",
    pageSize: 20
) {
    print(game.name)

    // Process games as they stream in
    // Break early if needed
    if someCondition {
        break
    }
}
```

### Other Resource Sequences

```swift
// All genres
for try await genre in await client.genresSequence() {
    print("\(genre.name): \(genre.gamesCount ?? 0) games")
}

// All platforms
for try await platform in await client.platformsSequence() {
    print(platform.name)
}

// Developers
for try await developer in await client.developersSequence() {
    print(developer.name)
}

// Publishers
for try await publisher in await client.publishersSequence() {
    print(publisher.name)
}

// Stores
for try await store in await client.storesSequence() {
    print(store.name)
}

// Tags
for try await tag in await client.tagsSequence() {
    print(tag.name)
}

// Creators
for try await creator in await client.creatorsSequence() {
    print(creator.name)
}
```

### Task Cancellation

AsyncSequences respect task cancellation:

```swift
let task = Task {
    var gameNames: [String] = []

    for try await game in await client.gamesSequence(pageSize: 20) {
        gameNames.append(game.name)

        if gameNames.count >= 100 {
            break
        }
    }

    return gameNames
}

// Cancel if needed
task.cancel()

// The sequence will stop fetching new pages
let result = await task.result
```

## Caching

RAWGKit includes intelligent caching to reduce API calls and improve performance.

### Cache Configuration

```swift
// Caching is enabled by default
let client = RAWGClient(apiKey: "your-api-key")

// Disable caching if needed
let noCacheClient = RAWGClient(
    apiKey: "your-api-key",
    cacheEnabled: false
)
```

### Cache Management

```swift
// Clear all cached data
await client.clearCache()

// Get cache statistics
let stats = await client.cacheStats()
print("Cached entries: \(stats.totalEntries)")
print("Cache hits: \(stats.hits)")
print("Cache misses: \(stats.misses)")
print("Hit ratio: \(stats.hitRatio)%")
```

### How Caching Works

- **NSCache-based**: Automatic memory eviction under system pressure
- **TTL Support**: Entries expire after 5 minutes by default
- **Thread-safe**: Safe to use from any thread/task
- **Size-aware**: Uses data size as cost for intelligent eviction
- **Default Limits**: 100 entries, 10MB total cost

## Custom Network Configuration

### Custom URLSession

Provide a custom URLSession for testing or special configurations:

```swift
let config = URLSessionConfiguration.default
config.timeoutIntervalForRequest = 60
config.timeoutIntervalForResource = 120

let session = URLSession(configuration: config)
let networkManager = NetworkManager(
    apiKey: "your-api-key",
    session: session
)

let client = RAWGClient(networkManager: networkManager)
```

### Network Manager Protocol

Implement ``NetworkManaging`` for complete control:

```swift
import RAWGKit

class CustomNetworkManager: NetworkManaging {
    func request<T: Decodable>(
        endpoint: RAWGEndpoint,
        page: Int?,
        pageSize: Int?
    ) async throws -> T {
        // Your custom implementation
        // Can add custom logging, metrics, etc.
    }
}

let client = RAWGClient(networkManager: CustomNetworkManager())
```

## Retry Policy

Configure automatic retries for transient failures:

```swift
// Default retry policy
// - 3 max retries
// - Exponential backoff (1s, 2s, 4s)
// - Retries on: timeout, connection errors, 5xx errors

// Custom retry policy
let customPolicy = RetryPolicy(
    maxRetries: 5,
    initialDelay: 2.0,
    backoffStrategy: .exponential
)

let networkManager = NetworkManager(
    apiKey: "your-api-key",
    retryPolicy: customPolicy
)

let client = RAWGClient(networkManager: networkManager)
```

### Retry Behavior

The retry policy automatically retries:
- Network timeouts
- Connection errors (no internet)
- Server errors (5xx status codes)
- Rate limiting (respects `Retry-After` header)

It does NOT retry:
- Client errors (4xx) - these indicate a problem with the request
- Decoding errors - the data format is wrong
- Unauthorized errors - the API key is invalid

## Request Deduplication

RAWGKit automatically deduplicates concurrent requests to the same endpoint:

```swift
// Both calls execute simultaneously
// Only ONE network request is made
async let games1 = client.fetchGameDetail(id: 3328)
async let games2 = client.fetchGameDetail(id: 3328)

let (result1, result2) = try await (games1, games2)

// Both results are identical
// Saved API quota and improved performance
```

## Convenience Methods

Quick access to common queries:

```swift
// Popular games (last 30 days, metacritic 75+)
let popular = try await client.fetchPopularGames()

// New releases (last 7 days)
let newReleases = try await client.fetchNewReleases()

// Upcoming games (next 180 days)
let upcoming = try await client.fetchUpcomingGames()

// Top rated (metacritic 90+)
let topRated = try await client.fetchTopRated()

// This year's releases
let thisYear = try await client.fetchThisYear()

// Trending (last 60 days, metacritic 70+)
let trending = try await client.fetchTrendingGames()
```

## Next Steps

- Learn about <doc:Security> features like certificate pinning and Keychain storage
- Explore <doc:Performance> optimization techniques
- Review the demo app at `Examples/RAWGKitDemo/` for real-world usage
