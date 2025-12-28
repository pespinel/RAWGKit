# Performance

Optimize your app's performance with RAWGKit's built-in features and best practices.

## Overview

RAWGKit is designed for optimal performance with features like intelligent caching, request deduplication, automatic retries, and efficient pagination. This guide covers performance optimization techniques and best practices.

## Caching Strategy

RAWGKit includes an intelligent caching system that significantly reduces API calls and improves responsiveness.

### How Caching Works

- **NSCache-based**: Automatic memory management and eviction under pressure
- **TTL Support**: Entries expire after 5 minutes by default
- **Thread-safe**: Actor-based implementation for safe concurrent access
- **Size-aware**: Uses data size as cost for intelligent eviction
- **Request Deduplication**: Prevents duplicate concurrent requests

### Cache Configuration

```swift
// Default: Caching enabled with NSCache
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")

// Disable caching if needed (not recommended)
let noCacheClient = RAWGClient(
    apiKey: "YOUR_API_KEY_HERE",
    cacheEnabled: false
)
```

### Cache Limits

Default cache limits (configurable in ``CacheManager``):
- **Count Limit**: 100 entries
- **Cost Limit**: 10 MB total
- **TTL**: 5 minutes

### Cache Performance

Performance benchmarks for cache operations:
- **Cache hit**: < 1ms average
- **Cache miss + network**: 100-500ms (network dependent)
- **Memory efficiency**: 100 entries in < 1ms average lookup
- **Statistics calculation**: < 10ms

### Monitoring Cache Performance

```swift
let stats = await client.cacheStats()

print("Total entries: \(stats.totalEntries)")
print("Cache hits: \(stats.hits)")
print("Cache misses: \(stats.misses)")
print("Hit ratio: \(stats.hitRatio)%")
print("Memory size: \(stats.memorySize) bytes")

// Calculate cache efficiency
if stats.hitRatio > 70 {
    print("✅ Cache is performing well")
} else {
    print("⚠️ Consider increasing cache limits or TTL")
}
```

### Cache Clearing Strategies

```swift
// Clear on user logout
func logout() async {
    await client.clearCache()
    // Clear other user data
}

// Clear on memory warning
NotificationCenter.default.addObserver(
    forName: UIApplication.didReceiveMemoryWarningNotification,
    object: nil,
    queue: .main
) { _ in
    Task {
        await client.clearCache()
    }
}

// Periodic clearing (e.g., daily)
Task {
    while !Task.isCancelled {
        try await Task.sleep(nanoseconds: 86_400_000_000_000) // 24 hours
        await client.clearCache()
    }
}
```

## Request Deduplication

RAWGKit automatically deduplicates concurrent requests to the same endpoint.

### How It Works

```swift
// Making 10 concurrent requests for the same game
async let r1 = client.fetchGameDetail(id: 3328)
async let r2 = client.fetchGameDetail(id: 3328)
async let r3 = client.fetchGameDetail(id: 3328)
// ... 7 more

// Only ONE network request is made
// All 10 calls receive the same result
let (game1, game2, game3) = try await (r1, r2, r3)
```

### Benefits

- **Reduced API Quota Usage**: Fewer requests = more quota available
- **Lower Network Traffic**: Less data transferred
- **Faster Response Times**: Concurrent calls complete together
- **Automatic**: No configuration needed

### When Deduplication Helps

- **SwiftUI Views**: Multiple views requesting the same data
- **Pagination**: Loading next page while current is still loading
- **Refresh**: User triggers refresh while load is in progress
- **Search**: Rapid search queries that overlap

## AsyncSequence Pagination

Use AsyncSequence for memory-efficient streaming of large datasets.

### Memory Efficiency

```swift
// ❌ BAD: Loads all 10,000 games into memory
var allGames: [Game] = []
var page = 1
while true {
    let response = try await client.fetchGames(page: page, pageSize: 100)
    allGames.append(contentsOf: response.results)
    if response.next == nil { break }
    page += 1
}
// Peak memory: All 10,000 games at once

// ✅ GOOD: Streams games one at a time
for try await game in await client.gamesSequence(pageSize: 100) {
    processGame(game) // Process and discard
}
// Peak memory: ~100 games at a time
```

### Benchmarks

AsyncSequence pagination memory efficiency:
- **Standard fetch**: Loads all results in memory
- **AsyncSequence**: Processes in chunks, releases memory
- **Memory savings**: Up to 90% for large datasets
- **Performance**: < 50ms per page fetch

### Early Termination

```swift
// Find first game matching criteria
for try await game in await client.gamesSequence() {
    if game.rating > 4.5 && game.metacritic ?? 0 > 90 {
        print("Found: \(game.name)")
        break // Stops fetching more pages
    }
}
```

## Retry Policy Optimization

Configure retries for optimal performance vs reliability balance.

### Default Policy

```swift
// Default: 3 retries, exponential backoff (1s, 2s, 4s)
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")
```

### Custom Retry Policies

```swift
// Aggressive: More retries for critical data
let aggressivePolicy = RetryPolicy(
    maxRetries: 5,
    initialDelay: 0.5,
    backoffStrategy: .exponential
)

// Conservative: Fewer retries for non-critical data
let conservativePolicy = RetryPolicy(
    maxRetries: 2,
    initialDelay: 2.0,
    backoffStrategy: .exponential
)

// Fast fail: No retries, immediate failure
let noRetryPolicy = RetryPolicy(
    maxRetries: 0,
    initialDelay: 0,
    backoffStrategy: .none
)
```

### Benchmarks

Retry policy performance characteristics:
- **No retry**: 0ms overhead, fails fast
- **Default (3 retries)**: Max 7s delay (1 + 2 + 4)
- **Aggressive (5 retries)**: Max 31s delay (0.5 + 1 + 2 + 4 + 8)

Choose based on your needs:
- **Critical data**: Aggressive retries
- **User-initiated**: Default retries
- **Background refresh**: Conservative retries
- **Real-time features**: Fast fail

## Network Performance

### Timeout Configuration

```swift
let config = URLSessionConfiguration.default
config.timeoutIntervalForRequest = 30  // Default: 60s
config.timeoutIntervalForResource = 120 // Default: 604800s (7 days)

let session = URLSession(configuration: config)
let networkManager = NetworkManager(
    apiKey: "YOUR_API_KEY_HERE",
    session: session
)
```

### HTTP/2 Support

RAWGKit automatically uses HTTP/2 when available:
- **Multiplexing**: Multiple requests over single connection
- **Header compression**: Reduced overhead
- **Server push**: Faster resource delivery

## Query Optimization

### Minimize Page Size

```swift
// ❌ BAD: Requesting more data than needed
let games = try await client.fetchGames(pageSize: 40)
// Displays only 10 games

// ✅ GOOD: Request only what you need
let games = try await client.fetchGames(pageSize: 10)
```

### Use Specific Queries

```swift
// ❌ BAD: Fetch all, filter in-app
let allGames = try await client.fetchGames(pageSize: 40)
let rpgGames = allGames.results.filter { game in
    game.genres?.contains { $0.name == "RPG" } ?? false
}

// ✅ GOOD: Filter on server
let rpgGames = try await client.gamesQuery()
    .genres([.rpg])
    .pageSize(10)
    .execute(with: client)
```

### Ordering on Server

```swift
// ❌ BAD: Sort in-app
let games = try await client.fetchGames()
let sorted = games.results.sorted { $0.rating > $1.rating }

// ✅ GOOD: Order on server
let games = try await client.fetchGames(ordering: "-rating")
```

## Batch Operations

### Concurrent Requests

```swift
// Fetch multiple resources concurrently
async let genres = client.fetchGenres()
async let platforms = client.fetchPlatforms()
async let stores = client.fetchStores()

let (genresResult, platformsResult, storesResult) = try await (
    genres,
    platforms,
    stores
)

// All three requests execute in parallel
// Much faster than sequential requests
```

### Task Groups

```swift
// Fetch details for multiple games
let gameIds = [3328, 3498, 1030, 58175]

let games = try await withThrowingTaskGroup(
    of: GameDetails.self
) { group in
    for id in gameIds {
        group.addTask {
            try await client.fetchGameDetail(id: id)
        }
    }

    var results: [GameDetails] = []
    for try await game in group {
        results.append(game)
    }
    return results
}

// All 4 game details fetched concurrently
```

## Actor-Based Concurrency

RAWGKit uses Swift actors for thread-safe, high-performance concurrent operations.

### Benefits

- **No Data Races**: Actor isolation prevents concurrent access bugs
- **No Locks**: No manual locking required
- **Efficient**: Compiler-optimized concurrent access
- **Safe**: Thread-safety guaranteed at compile time

### Actor Usage

```swift
// NetworkManager is an actor
// All methods are async and actor-isolated
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")

// Safe concurrent access
Task {
    let games1 = try await client.fetchGames()
}

Task {
    let games2 = try await client.fetchGameDetail(id: 3328)
}

// No data races, no locks needed
```

## Performance Monitoring

### Logging

Enable logging to monitor performance:

```swift
// In DEBUG builds, RAWGKit logs:
// - Request timing
// - Cache hits/misses
// - Retry attempts
// - Response sizes

// Check console for logs:
// [RAWGKit] GET /api/games - 245ms (cache miss)
// [RAWGKit] GET /api/games/3328 - 12ms (cache hit)
```

### Metrics to Track

1. **Cache hit ratio**: Should be > 70% for good performance
2. **Average response time**: < 500ms for cached, < 2s for network
3. **Retry frequency**: Should be < 5% of requests
4. **Memory usage**: Monitor with Instruments

## Best Practices

### ✅ Do

- Use caching (enabled by default)
- Request only the data you need
- Use AsyncSequence for large datasets
- Batch concurrent requests with Task Groups
- Monitor cache hit ratio
- Clear cache on memory warnings
- Use type-safe query filters
- Order and filter on the server

### ❌ Don't

- Disable caching without good reason
- Fetch large page sizes unnecessarily
- Load all data into memory at once
- Make sequential requests when concurrent is possible
- Ignore cache statistics
- Hard-code large timeout values
- Filter/sort in-app when server can do it

## Profiling with Instruments

### Memory Profiling

1. Run your app with Instruments (Cmd+I in Xcode)
2. Select "Allocations" template
3. Look for:
   - Memory growth during pagination
   - Retained cache entries
   - Peak memory during large fetches

### Network Profiling

1. Select "Network" template in Instruments
2. Monitor:
   - Request count (should decrease with caching)
   - Response times
   - Data transferred
   - Concurrent connections

## Performance Checklist

- [ ] Caching is enabled
- [ ] Cache hit ratio > 70%
- [ ] Using appropriate page sizes (10-20 for UI)
- [ ] Concurrent requests where possible
- [ ] AsyncSequence for large datasets
- [ ] Server-side filtering and ordering
- [ ] Monitoring cache statistics
- [ ] Memory warnings handled
- [ ] Appropriate retry policy configured
- [ ] Request deduplication working

## Next Steps

- Review <doc:Security> for security best practices
- Explore <doc:AdvancedFeatures> for complex use cases
- Check the demo app for performance implementation examples
