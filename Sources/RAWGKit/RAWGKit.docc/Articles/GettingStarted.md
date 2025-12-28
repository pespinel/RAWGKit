# Getting Started with RAWGKit

Learn how to install RAWGKit and make your first API calls.

## Overview

This guide will walk you through installing RAWGKit, obtaining an API key, and making your first requests to the RAWG API.

## Installation

### Swift Package Manager

Add RAWGKit to your project using Swift Package Manager:

1. In Xcode, select **File → Add Packages...**
2. Enter the repository URL: `https://github.com/pespinel/RAWGKit`
3. Select the version and add it to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pespinel/RAWGKit", from: "1.0.0")
]
```

## Getting an API Key

1. Visit [https://rawg.io/apidocs](https://rawg.io/apidocs)
2. Create a free account or log in
3. Navigate to your API section to get your API key
4. Store your API key securely using Keychain (recommended)

### Storing API Key in Keychain

For maximum security, store your API key in the iOS Keychain:

```swift
import RAWGKit

// Initialize client and save API key to Keychain
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")
try await client.saveAPIKeyToKeychain()

// Later, initialize client from Keychain
let client = try await RAWGClient.initWithKeychain()
```

## Basic Usage

### Initializing the Client

```swift
import RAWGKit

// Initialize with API key
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")

// Or initialize from Keychain
let client = try await RAWGClient.initWithKeychain()
```

### Fetching Games

```swift
// Fetch popular games
let games = try await client.fetchGames(
    pageSize: 20,
    ordering: "-rating"
)

for game in games.results {
    print("\(game.name) - Rating: \(game.rating)")
}
```

### Getting Game Details

```swift
// Fetch detailed information about a specific game
let gameId = 3498 // GTA V
let gameDetail = try await client.fetchGameDetail(id: gameId)

print("Name: \(gameDetail.name)")
print("Description: \(gameDetail.description ?? "No description")")
print("Rating: \(gameDetail.rating)")
print("Metacritic: \(gameDetail.metacritic ?? 0)")
```

### Searching for Games

```swift
// Simple search
let results = try await client.fetchGames(
    search: "The Witcher",
    ordering: "-rating"
)

// Using the query builder (recommended)
let filtered = try await client.gamesQuery()
    .search("cyberpunk")
    .platforms([.pc, .playStation5])
    .genres([.action, .rpg])
    .metacriticMin(80)
    .pageSize(20)
    .execute(with: client)

print("Found \(filtered.count) games")
```

## Exploring Other Resources

### Genres

```swift
// Get all genres
let genres = try await client.fetchGenres()
for genre in genres.results {
    print("\(genre.name): \(genre.gamesCount ?? 0) games")
}

// Get genre details
let actionGenre = try await client.fetchGenreDetails(id: 4)
print(actionGenre.description ?? "")
```

### Platforms

```swift
// Get all platforms
let platforms = try await client.fetchPlatforms()

// Get platform details
let pc = try await client.fetchPlatformDetails(id: 4)
print("Platform: \(pc.name)")
```

### Developers and Publishers

```swift
// Get developers
let developers = try await client.fetchDevelopers()

// Get developer details
let rockstar = try await client.fetchDeveloperDetails(id: 3524)
print("Developer: \(rockstar.name)")

// Get publishers
let publishers = try await client.fetchPublishers()
```

## Error Handling

Always handle errors appropriately when making API calls:

```swift
do {
    let games = try await client.fetchGames()
    // Process games
} catch NetworkError.unauthorized {
    print("Invalid API key")
} catch NetworkError.rateLimitExceeded(let retryAfter) {
    print("Rate limit exceeded. Retry after: \(retryAfter ?? "unknown")")
} catch NetworkError.noInternetConnection {
    print("No internet connection")
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## Next Steps

- Learn about <doc:SwiftUIIntegration> for building user interfaces
- Explore <doc:AdvancedFeatures> like pagination and complex queries
- Check out <doc:Security> for best practices on securing your app
- Review <doc:Performance> for optimization tips
