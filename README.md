# RAWGKit

[![CI](https://github.com/pespinel/RAWGKit/actions/workflows/ci.yml/badge.svg)](https://github.com/pespinel/RAWGKit/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/pespinel/RAWGKit/branch/main/graph/badge.svg)](https://codecov.io/gh/pespinel/RAWGKit)
[![Swift Version](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS-blue.svg)](https://developer.apple.com)
[![Tests](https://img.shields.io/badge/Tests-389%20passing-brightgreen.svg)](https://github.com/pespinel/RAWGKit/actions)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modern, Swift-native SDK for the RAWG Video Games Database API with first-class SwiftUI support.

## Features

- 🎨 **SwiftUI First-Class**: Ready-to-use ViewModels, UI components, and [demo app](Examples/RAWGKitDemo/)
- ✅ **Complete API Coverage**: Access to all RAWG API endpoints (games, platforms, genres, stores, creators, and more)
- 🔒 **Type-Safe**: Fully typed responses with Codable models and compile-time safe query filters
- ⚡ **Modern Swift**: Built with async/await and AsyncSequence for clean, readable asynchronous code
- 🎯 **Actor-Based Networking**: Thread-safe operations with Swift's actor model and request deduplication
- 📱 **Cross-Platform**: iOS 15+, macOS 13+, watchOS 8+, tvOS 15+, visionOS 1+
- 🔨 **Fluent Query Builder**: Type-safe API with enums for platforms, genres, stores, and ordering
- 🔄 **Auto-Pagination**: Stream large result sets efficiently with AsyncSequence support
- 💾 **Smart Caching**: In-memory NSCache with TTL and automatic memory management
- 🔁 **Automatic Retries**: Configurable retry policy with exponential backoff for failed requests
- 📊 **Structured Logging**: Built-in logging with os.Logger for debugging and monitoring
- 📄 **Comprehensive Documentation**: Full DocC documentation with examples and best practices
- ✨ **Strict Concurrency**: Sendable-compliant for safe concurrent usage

## Requirements

- Swift 6.0+
- iOS 15.0+ / macOS 13.0+ / watchOS 8.0+ / tvOS 15.0+ / visionOS 1.0+
- Xcode 16.0+

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

### SwiftUI Integration

RAWGKit provides ready-to-use SwiftUI components and ViewModels:

```swift
import RAWGKit
import SwiftUI

struct GamesListView: View {
    @StateObject private var viewModel = GamesViewModel(
        client: RAWGClient(apiKey: "your-api-key")
    )
    
    var body: some View {
        List(viewModel.games) { game in
            GameRowView(game: game) // Pre-built component
        }
        .searchable(text: $viewModel.searchText)
        .refreshable {
            await viewModel.loadGames()
        }
        .task {
            await viewModel.loadGames()
        }
    }
}
```

**Included Components:**
- `GamesViewModel` - Observable state management with search, filters, and pagination
- `GameRowView` - Pre-styled game list row
- `GameImageView` - Async image loading with placeholder
- `RatingBadgeView` - Color-coded rating display

👉 **[See full SwiftUI demo app](Examples/RAWGKitDemo/)** with search, filters, and infinite scrolling.

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
- `fetchGameTwitchStreams(id:page:pageSize:)` - Get Twitch streams
- `fetchGameYouTubeVideos(id:page:pageSize:)` - Get YouTube videos

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

## Performance & Architecture

RAWGKit is designed for optimal performance and reliability:

### Request Deduplication
Prevents duplicate simultaneous requests to the same URL, reducing API quota usage and improving performance:
```swift
// Multiple concurrent calls to the same endpoint
// Only makes ONE actual network request
async let games1 = client.fetchGameDetail(id: 3328)
async let games2 = client.fetchGameDetail(id: 3328)
let (result1, result2) = try await (games1, games2)
```

### Automatic Retries
Configurable retry policy with exponential backoff for transient failures:
- Retries on network timeouts, connection losses, and server errors (5xx)
- Respects `Retry-After` headers for rate limiting
- Default: 3 retries with exponential backoff
- Does NOT retry on client errors (4xx) or decoding errors

### Actor-Based Networking
All network operations use Swift's actor model for thread safety:
- Prevents data races and synchronization issues
- Safe concurrent access from multiple tasks
- No need for locks or dispatch queues

### Structured Logging
Built-in logging with `os.Logger` for debugging and monitoring:
- Network requests and responses
- Cache hits and misses
- Decoding errors with JSON output
- Performance metrics

## Code Quality & Testing

RAWGKit maintains high code quality standards with automated tooling and comprehensive tests:

### Testing
- **113+ tests** with Swift Testing framework
- Unit tests for all core components
- Integration tests with real API
- AsyncSequence pagination tests
- Concurrency and actor isolation tests
- **100% test pass rate** on CI

### Code Quality Tools
- **SwiftLint**: Enforces Swift style and conventions (strict mode)
- **SwiftFormat**: Automatic code formatting in pre-commit hooks
- **Strict Concurrency Checking**: Enabled for maximum safety
- **Continuous Integration**: Automated testing on macOS 13 & 14

### CI/CD Pipeline
The project uses GitHub Actions for:
- ✅ Linting (SwiftLint)
- ✅ Formatting (SwiftFormat)
- ✅ Testing on multiple macOS versions
- ✅ Code coverage reporting

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our development process, code style, and how to submit pull requests.

### Quick Start for Contributors

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

## Examples

Check out the [Examples/](Examples/) directory for comprehensive usage examples:

- **[BasicUsage.swift](Examples/BasicUsage.swift)** - Client initialization, fetching games, searching, error handling, caching
- **[AdvancedQueries.swift](Examples/AdvancedQueries.swift)** - Query builder, filtering, date ranges, complex queries
- **[AsyncSequences.swift](Examples/AsyncSequences.swift)** - Streaming large datasets, pagination, task cancellation

## Support

- 📚 [RAWG API Documentation](https://api.rawg.io/docs/)
- 🐛 [Report Issues](https://github.com/pespinel/RAWGKit/issues)
- � [Feature Requests](https://github.com/pespinel/RAWGKit/issues/new/choose)
