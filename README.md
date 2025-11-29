# RAWGKit

A modern, Swift-native SDK for the RAWG Video Games Database API.

## Features

- ✅ **Complete API Coverage**: Access to all RAWG API endpoints
- 🔒 **Type-Safe**: Fully typed responses with Codable models
- ⚡ **Modern Swift**: Uses async/await for clean, readable code
- 🎯 **Actor-Based**: Thread-safe networking with Swift's actor model
- 📱 **Cross-Platform**: Supports iOS 15+, macOS 12+, watchOS 8+, tvOS 15+
- 🔨 **Query Builder**: Fluent API for building complex queries
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
let response = try await client.gamesQuery()
    .search("witcher")
    .orderByRating()
    .year(2015)
    .platforms([4, 18, 1]) // PC, PS4, Xbox One
    .metacriticMin(80)
    .pageSize(20)
    .execute(with: client)

print("Found \(response.count) games")
```

### Search for Games

```swift
// Simple search
let results = try await client.fetchGames(
    search: "The Witcher",
    ordering: "-rating"
)

// Advanced search with filters
let filtered = try await client.fetchGames(
    search: "cyberpunk",
    searchExact: true,
    platforms: [4], // PC
    genres: [4], // Action
    dates: "2020-01-01,2023-12-31",
    metacritic: "80,100"
)
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

## Code Quality

RAWGKit uses industry-standard tools to ensure code quality:

- **SwiftLint**: Enforces Swift style and conventions
- **SwiftFormat**: Ensures consistent code formatting
- **Swift Testing**: Modern testing framework with 35+ tests

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

Before contributing:
1. Run `swiftlint --fix` to auto-fix style issues
2. Run `swiftformat .` to format your code
3. Ensure all tests pass with `swift test`

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Data provided by [RAWG.io](https://rawg.io)
- Built with ❤️ using Swift

## Support

- 📚 [RAWG API Documentation](https://api.rawg.io/docs/)
- 🐛 [Report Issues](https://github.com/pespinel/RAWGKit/issues)
- 💬 [Discussions](https://github.com/pespinel/RAWGKit/discussions)
