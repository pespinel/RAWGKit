# RAWGKit

A modern, Swift-native SDK for the RAWG Video Games Database API.

## Features

- ✅ **Complete API Coverage**: Access to all RAWG API endpoints
- 🔒 **Type-Safe**: Fully typed responses with Codable models and type-safe query filters
- ⚡ **Modern Swift**: Uses async/await and AsyncSequence for clean, readable code
- 🎯 **Actor-Based**: Thread-safe networking with Swift's actor model
- 📱 **Cross-Platform**: Supports iOS 15+, macOS 12+, watchOS 8+, tvOS 15+, visionOS 1+
- 🔨 **Query Builder**: Fluent API with type-safe enums for platforms, genres, stores
- 🔄 **Auto-Pagination**: AsyncSequence support for iterating through all results
- 💾 **Smart Caching**: NSCache-based caching with automatic memory management
- 📄 **Well-Documented**: Comprehensive documentation and examples

## Installation

### Swift Package Manager

Add RAWGKit to your project via Xcode:

1. File → Add Packages...
2. Enter package URL: `https://github.com/pespinel/RAWGKit`
3. Select version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pespinel/RAWGKit", from: "1.0.0")
]
```

## Quick Start

### Get Your API Key

1. Visit [https://rawg.io/apidocs](https://rawg.io/apidocs)
2. Create an account or log in
3. Get your free API key

### Basic Usage

```swift
import RAWGKit

// Initialize the client
let client = RAWGClient(apiKey: "your-api-key-here")

// Fetch popular games
let games = try await client.fetchGames(
    pageSize: 10,
    ordering: "-rating"
)

for game in games.results {
    print("\(game.name) - Rating: \(game.rating)")
}

// Get game details
let gameDetail = try await client.fetchGameDetail(id: 3498)
print(gameDetail.description ?? "No description")

// Get screenshots
let screenshots = try await client.fetchGameScreenshots(id: 3498)
for screenshot in screenshots.results {
    print(screenshot.image)
}
```

## Advanced Usage

### Using the Query Builder

```swift
// Type-safe query with enums (recommended)
let response = try await client.gamesQuery()
    .search("witcher")
    .orderByRating()
    .year(2015)
    .platforms([.pc, .playStation4, .xboxOne])
    .genres([.rpg, .action])
    .metacriticMin(80)
    .pageSize(20)
    .execute(with: client)

print("Found \(response.count) games")
```

### Type-Safe Filters

RAWGKit provides type-safe enums for common filters:

```swift
// Platforms
.platforms([.pc, .playStation5, .xboxSeriesX, .nintendoSwitch])
.parentPlatforms([.playStation, .xbox, .nintendo])

// Genres
.genres([.action, .rpg, .adventure, .shooter])

// Stores
.stores([.steam, .epicGames, .playStationStore, .nintendoStore])

// Ordering
.ordering(.metacriticDescending)
.ordering(.releasedDescending)
```

### Date Helpers

```swift
// Games released this year
.releasedThisYear()

// Games from a specific date range
.releasedBetween(from: startDate, to: endDate)

// Games released in the last 30 days
.releasedInLast(days: 30)

// Games released after a date
.releasedAfter(someDate)

// Games released before a date
.releasedBefore(someDate)
```

### Async Sequences for Pagination

Automatically paginate through all results:

```swift
// Iterate through all games matching a query
for try await game in client.allGames(search: "zelda") {
    print(game.name)
}

// Iterate through all genres
for try await genre in client.allGenres() {
    print(genre.name)
}

// Also available: allPlatforms(), allDevelopers(), allPublishers(), 
// allStores(), allTags(), allCreators()
```

### Search for Games

```swift
// Simple search
let results = try await client.fetchGames(
    search: "The Witcher",
    ordering: "-rating"
)

// Advanced search with query builder (recommended)
let filtered = try await client.gamesQuery()
    .search("cyberpunk")
    .searchExact()
    .platforms([.pc])
    .genres([.action])
    .releasedBetween(from: startDate, to: endDate)
    .metacritic(min: 80, max: 100)
    .execute(with: client)
```

### Explore Genres, Platforms, and More

```swift
// Get all genres
let genres = try await client.fetchGenres()
for genre in genres.results {
    print("\(genre.name): \(genre.gamesCount ?? 0) games")
}

// Get genre details
let genreDetails = try await client.fetchGenreDetails(id: 4)
print(genreDetails.description ?? "")

// Get platforms
let platforms = try await client.fetchPlatforms()

// Get parent platforms (PlayStation, Xbox, PC, etc.)
let parentPlatforms = try await client.fetchParentPlatforms()

// Get developers
let developers = try await client.fetchDevelopers()

// Get developer details
let devDetails = try await client.fetchDeveloperDetails(id: 1)

// Get publishers
let publishers = try await client.fetchPublishers()

// Get stores
let stores = try await client.fetchStores()

// Get tags
let tags = try await client.fetchTags()
```

### Game Details and Related Content

```swift
let gameId = 3498 // GTA V

// Get full game details
let game = try await client.fetchGameDetail(id: gameId)
print(game.name)
print(game.description ?? "")
print("Rating: \(game.rating)")
print("Metacritic: \(game.metacritic ?? 0)")

// Get screenshots
let screenshots = try await client.fetchGameScreenshots(id: gameId)

// Get trailers/movies
let movies = try await client.fetchGameMovies(id: gameId)

// Get achievements
let achievements = try await client.fetchGameAchievements(id: gameId)
for achievement in achievements.results {
    print("\(achievement.name): \(achievement.percent ?? "0")%")
}

// Get DLC and editions
let additions = try await client.fetchGameAdditions(id: gameId)

// Get games in the same series
let series = try await client.fetchGameSeries(id: gameId)

// Get development team
let team = try await client.fetchGameDevelopmentTeam(id: gameId)

// Get where to buy
let gameStores = try await client.fetchGameStores(id: gameId)

// Get Reddit posts
let redditPosts = try await client.fetchGameRedditPosts(id: gameId)
```

### Creators

```swift
// Get all creators
let creators = try await client.fetchCreators()

// Get creator details
let creator = try await client.fetchCreatorDetails(id: "78")

// Get creator roles/positions
let roles = try await client.fetchCreatorRoles()
```

## API Reference

### RAWGClient

The main client for interacting with the RAWG API.

#### Initialization

```swift
let client = RAWGClient(apiKey: "your-api-key")
```

#### Games

- `fetchGames(...)` - Get a list of games with optional filters
- `fetchGameDetail(id:)` - Get detailed game information
- `fetchGameScreenshots(id:page:pageSize:)` - Get game screenshots
- `fetchGameMovies(id:)` - Get game trailers
- `fetchGameAdditions(id:page:pageSize:)` - Get DLC and editions
- `fetchGameSeries(id:page:pageSize:)` - Get games in the same series
- `fetchGameParentGames(id:page:pageSize:)` - Get parent games
- `fetchGameDevelopmentTeam(id:page:pageSize:)` - Get development team
- `fetchGameStores(id:page:pageSize:)` - Get store links
- `fetchGameAchievements(id:)` - Get achievements
- `fetchGameRedditPosts(id:)` - Get Reddit posts

#### Genres

- `fetchGenres(page:pageSize:ordering:)` - Get all genres
- `fetchGenreDetails(id:)` - Get genre details

#### Platforms

- `fetchPlatforms(page:pageSize:ordering:)` - Get all platforms
- `fetchPlatformDetails(id:)` - Get platform details
- `fetchParentPlatforms(page:pageSize:ordering:)` - Get parent platforms

#### Developers

- `fetchDevelopers(page:pageSize:)` - Get all developers
- `fetchDeveloperDetails(id:)` - Get developer details

#### Publishers

- `fetchPublishers(page:pageSize:)` - Get all publishers
- `fetchPublisherDetails(id:)` - Get publisher details

#### Stores

- `fetchStores(page:pageSize:ordering:)` - Get all stores
- `fetchStoreDetails(id:)` - Get store details

#### Tags

- `fetchTags(page:pageSize:)` - Get all tags
- `fetchTagDetails(id:)` - Get tag details

#### Creators

- `fetchCreators(page:pageSize:)` - Get all creators
- `fetchCreatorDetails(id:)` - Get creator details
- `fetchCreatorRoles(page:pageSize:)` - Get creator roles

## Models

### Game

Basic game information for list views.

### GameDetail

Detailed game information including description, ratings, platforms, genres, developers, publishers, and more.

### Genre, Platform, Developer, Publisher, Store, Tag, Creator

Resource models with basic information and game counts.

### Screenshot, Movie, Achievement, RedditPost

Related content models.

## Ordering

You can order results using the `ordering` parameter:

- `"name"` - Sort by name (A-Z)
- `"-name"` - Sort by name (Z-A)
- `"released"` - Sort by release date (oldest first)
- `"-released"` - Sort by release date (newest first)
- `"rating"` - Sort by rating (lowest first)
- `"-rating"` - Sort by rating (highest first)
- `"metacritic"` - Sort by Metacritic score (lowest first)
- `"-metacritic"` - Sort by Metacritic score (highest first)
- `"added"` - Sort by date added to RAWG
- `"-added"` - Sort by date added to RAWG (newest first)

## Error Handling

```swift
do {
    let games = try await client.fetchGames()
    // Handle success
} catch NetworkError.unauthorized {
    print("Invalid API key")
} catch NetworkError.rateLimitExceeded(let message) {
    print("Rate limit: \(message)")
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## Rate Limiting

The free tier has rate limits:
- Be respectful of the API
- Cache responses when possible
- Consider upgrading for higher limits

## Terms of Use

- ✅ Free for personal use (with attribution)
- ✅ Free for commercial use (<100k MAU or <500k page views/month)
- ❌ No cloning the RAWG website
- 📝 Attribution required: Link to RAWG.io

See [RAWG API Terms](https://rawg.io/apidocs) for full details.

## Requirements

- iOS 15.0+ / macOS 13.0+ / watchOS 8.0+ / tvOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## Caching

RAWGKit includes smart caching with automatic memory management:

```swift
// Caching is enabled by default
let client = RAWGClient(apiKey: "your-api-key")

// Disable caching if needed
let clientNoCache = RAWGClient(apiKey: "your-api-key", cacheEnabled: false)

// Clear cache manually
await client.clearCache()

// Get cache statistics
let stats = await client.cacheStats()
print("Cached entries: \(stats.totalEntries)")
```

Features:
- **NSCache-based**: Automatic eviction under memory pressure
- **TTL support**: Entries expire after 5 minutes by default
- **Thread-safe**: Safe to use from any thread/task

## Code Quality

RAWGKit uses industry-standard tools to ensure code quality:

- **SwiftLint**: Enforces Swift style and conventions
- **SwiftFormat**: Ensures consistent code formatting
- **Swift Testing**: Modern testing framework with 100+ tests

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Set up your development environment:
```bash
# Install tools and git hooks
make setup
```

Or manually:
```bash
brew install swiftlint swiftformat
make install-hooks
```

2. The project includes a `Makefile` with helpful commands:
```bash
make help           # Show all available commands
make setup          # Install tools and git hooks
make lint           # Run SwiftLint
make format         # Run SwiftFormat
make test           # Run tests
make pre-commit     # Format, lint, and test
make check          # Run all checks (CI simulation)
```

### Before Submitting a PR

```bash
# Run all checks
make pre-commit

# Or run CI simulation
make check
```

The CI will also run these checks on your PR.

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Data provided by [RAWG.io](https://rawg.io)
- Built with ❤️ using Swift

## Support

- 📚 [RAWG API Documentation](https://api.rawg.io/docs/)
- 🐛 [Report Issues](https://github.com/pespinel/RAWGKit/issues)
- 💬 [Discussions](https://github.com/pespinel/RAWGKit/discussions)
