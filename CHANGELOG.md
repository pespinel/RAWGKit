# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0]

### Added
- 101 new unit tests for improved code coverage
  - 32 tests for `RAWGClient` (initialization, URL building, method signatures, cache control)
  - 13 tests for `NetworkManager` (edge cases, initialization variants, cache management)
  - 7 tests for `GamesViewModel` (state management, pagination, search, filters)
  - 53 tests for `RAWGEndpoint` (all endpoint paths, edge cases with IDs)
  - 14 tests for GameContent models (Achievement, Screenshot, Movie, GameStore, etc.)
  - Total tests: 254 (was 153)
- Comprehensive DocC documentation for all public types, properties, and methods
- Detailed documentation for all model structs (Game, GameDetails, Genres, Platforms, etc.)
- Complete API documentation for RAWGClient with usage examples
- Documentation for all type aliases in Alias.swift
- `Hashable` conformance to all primary models for SwiftUI performance optimizations
  - Core models: `Game`, `GameDetail`, `RAWGResponse`
  - Resources: `Developer`, `Publisher`, `GenreDetails`, `PlatformDetails`, `DeveloperDetails`, `PublisherDetails`, `StoreDetails`, `TagDetails`, `CreatorDetails`
  - GameContent: `Achievement`, `Screenshot`, `Clip`, `Clips`, `Movie`, `MovieData`, `RedditPost`, `GameStore`, `ScreenshotsResponse`
  - Metadata: `Rating`
- `GamesViewModel` - SwiftUI-ready ViewModel with state management
  - ObservableObject with @Published properties for automatic UI updates
  - Pagination support with `loadMore()` and `canLoadMore` property
  - Search with 300ms debouncing
  - Filter support for platforms, genres, and ordering
  - Structured error handling with retry support
  - Compatible with iOS 15+, macOS 13+
- SwiftUI components and extensions
  - `GameImageView` - Async image view with placeholder and error handling
  - `GameRowView` - Reusable list row component for games
  - `RatingBadgeView` - Color-coded rating badge view
  - `View+Loading` extensions - `.showLoading()`, `.showError()`, `.showEmptyState()` modifiers
  - All components compatible with iOS 15+, macOS 13+, tvOS 15+, watchOS 8+
- Complete SwiftUI demo app (RAWGKitDemo)
  - Full iOS app demonstrating RAWGKit integration
  - Game list with search, filters, and infinite scrolling
  - Platform and genre filter selection
  - Pull-to-refresh and error handling
  - Secure configuration with xcconfig files
  - Screenshots and comprehensive setup guide
  - iOS 15+ compatible with NavigationView and async/await
- Platform and Genre popular constants for improved developer experience
  - `Platform.Popular` namespace with 10 commonly-used platforms (PC, PlayStation, Xbox, Nintendo, mobile, desktop)
  - `Genre.Popular` namespace with 13 popular genres (Action, RPG, Strategy, etc.)
  - Each constant includes official RAWG API IDs
  - `.all` arrays for iteration in UI filters
  - Replaces arcaic tuple-based approach with type-safe constants
- Query builder convenience methods and extensions
  - `platformsPopular(_:)` - Filter by Platform.Popular constants
  - `genresPopular(_:)` - Filter by Genre.Popular constants
  - Static factory methods for common queries:
    - `.popularGames()` - Popular recent releases (30 days, metacritic 75+)
    - `.newReleases()` - Games from last 7 days
    - `.upcomingGames()` - Upcoming releases (next 180 days)
    - `.topRated()` - Highest-rated games (metacritic 90+)
    - `.thisYear()` - Current year releases
    - `.trending()` - Trending games (60 days, metacritic 70+)
- RAWGClient convenience methods for quick access
  - `fetchPopularGames()` - Direct access to popular games
  - `fetchNewReleases()` - Quick access to new releases
  - `fetchUpcomingGames()` - Fetch upcoming games easily
  - `fetchTopRated()` - Fetch top-rated games
  - `fetchThisYear()` - Fetch games from current year
  - `fetchTrendingGames()` - Fetch trending games
  - `fetchTopRated()` - Get top-rated games
  - `fetchThisYear()` - Current year releases
  - `fetchTrendingGames()` - Trending games shortcut

### Changed
- Reorganized test structure to mirror Sources/ organization
- Tests now organized in Unit/ (Core/, Networking/, Extensions/) and Integration/ subdirectories
- Improved test discoverability and maintenance
- All primary models now conform to `Hashable` for better SwiftUI List and Set performance
- Enhanced SwiftUI compatibility across all data models
- Demo app now uses `Platform.Popular` and `Genre.Popular` constants instead of hardcoded tuples
- Query builder now supports fluent chaining with Platform.Popular and Genre.Popular constants
- All convenience queries support method chaining for customization

### Fixed
- Swift 6.0.3 compiler compatibility
  - Added `-Xfrontend -disable-round-trip-debug-types` flag to work around Swift 6.0.3 compiler crash with SwiftUI debug types
  - Replaced `.foregroundStyle()` with `.foregroundColor()` for better compatibility
  - Simplified GameImageView structure

## [2.1]

### Added
- GitHub issue templates (bug report, feature request, documentation)
- Pull request template with comprehensive checklist
- Coverage reporting in CI pipeline with lcov generation
- Centralized constants in `RAWGConstants` for API limits, cache settings, and network timeouts
- Structured logging with `os.Logger` through `RAWGLogger`
- Request deduplication in NetworkManager to prevent duplicate concurrent requests
- Comprehensive DocC documentation for all public APIs
- `cancelAllRequests()` method in NetworkManager for canceling all active network tasks

### Changed
- NetworkManager refactored with extracted helper methods for improved maintainability
- README enhanced with badges, requirements section, expanded features, and architecture details

### Improved
- Better code organization through centralized constants
- Enhanced debugging with structured logging replacing print statements
- Improved performance through request deduplication
- Better developer experience with comprehensive API documentation

## [2.0]

### Added
- visionOS support
- Makefile for development workflow (`make setup`, `make test`, `make lint`, etc.)
- Configurable request timeout in NetworkManager
- Task cancellation support for AsyncSequences
- New AsyncSequences for all resources:
  - `developersSequence()` - Stream developers with automatic pagination
  - `publishersSequence()` - Stream publishers with automatic pagination
  - `storesSequence()` - Stream stores with automatic pagination
  - `tagsSequence()` - Stream tags with automatic pagination
  - `creatorsSequence()` - Stream creators with automatic pagination
- **Type-safe query filters** with enums for better DX:
  - `KnownPlatform` - PC, PlayStation, Xbox, Nintendo, mobile platforms
  - `KnownParentPlatform` - Platform categories (PlayStation, Xbox, Nintendo, etc.)
  - `KnownGenre` - Action, RPG, Adventure, Shooter, and more
  - `KnownStore` - Steam, Epic Games, PlayStation Store, Nintendo Store, etc.
  - `GameOrdering` - Type-safe ordering options
- **Date helpers** in GamesQueryBuilder:
  - `releasedThisYear()` - Filter games from current year
  - `releasedBetween(from:to:)` - Filter by date range with Date objects
  - `releasedAfter(_:)` / `releasedBefore(_:)` - Filter by single date
  - `releasedInLast(days:)` - Filter games from last N days
  - `updatedBetween(from:to:)` - Filter by update date range
- `metacritic(min:max:)` - Type-safe Metacritic range filter with clamping
- **Twitch and YouTube endpoints**:
  - `fetchGameTwitchStreams(id:)` - Get Twitch streams for a game
  - `fetchGameYouTubeVideos(id:)` - Get YouTube videos for a game
  - New models: `TwitchStream`, `YouTubeVideo`, `YouTubeThumbnails`

### Changed
- NetworkManager now accepts custom URLSession for testing
- Removed unused SwiftLint/SwiftFormat SPM dependencies (use CLI instead)
- AsyncSequences refactored to use generic helper, reducing code duplication
- Enabled StrictConcurrency experimental feature
- **CacheManager refactored to use NSCache**:
  - Automatic memory eviction under system pressure
  - Configurable `countLimit` (default: 100 entries)
  - Configurable `totalCostLimit` (default: 10MB)
  - Uses data size as cost for intelligent eviction
  - Maintains TTL support via wrapper class
- Test count increased to 103 (was 77)

### Removed
- Unused `ResourceProtocol.swift` with empty protocol definitions (dead code cleanup)

### Fixed
- NetworkManager `session` parameter was being ignored
- Unnecessary URLCache configuration removed (we use CacheManager)

### Documentation
- Updated README with improved development setup instructions
- Added `make setup` for one-command dev environment setup
- Added documentation for type-safe query filters
- Added documentation for AsyncSequences and caching

## [1.2]

### Added
- Public API for cache control in RAWGClient
  - `clearCache()` - Clear all cached responses
  - `cacheStats()` - Get cache statistics
  - `cacheEnabled` parameter in init to enable/disable caching
- Retry logic with exponential backoff
  - `RetryPolicy` for configuring retry behavior
  - Automatic retry for transient errors (timeout, no internet, 5xx)
  - Configurable max retries, delays, and backoff strategy
- AsyncSequence support for infinite pagination
  - `gamesSequence()` - Stream games with automatic pagination
  - `genresSequence()` - Stream genres with automatic pagination
  - `platformsSequence()` - Stream platforms with automatic pagination
- Comprehensive test coverage for new features
  - CacheManager tests (7 tests)
  - RAWGResponse extensions tests (12 tests)
  - NetworkError tests (11 tests)
  - RetryPolicy tests (20 tests)
  - Total: 77 tests (was 35)

### Changed
- Made CacheManager and CacheStats public for external access
- CacheStats now conforms to Sendable for thread-safety

## [1.1]

### Added
- In-memory caching system for API responses
  - Configurable TTL (default 5 minutes)
  - Cache statistics and management methods
  - Automatic cache invalidation
- RAWGResponse extensions for better pagination support
  - `currentPage` - Calculate current page number
  - `hasPreviousPage` - Check for previous page
  - `estimatedTotalPages` - Estimate total pages
  - `progress` - Progress through results (0.0-1.0)
- Resource protocols for common model patterns
  - `BasicResource` - Base protocol with id, name, slug
  - `ImageResource` - Includes image background
  - `GameCountResource` - Includes games count
  - `DetailedResource` - Includes description and details

### Changed
- Reorganized Models folder into semantic subcategories
  - `Core/` - Main models (Game, GameDetail, RAWGResponse)
  - `Resources/` - API resources (Genre, Platform, Store, etc.)
  - `GameContent/` - Game-related content (Achievement, Screenshot, etc.)
  - `Metadata/` - Metadata and classifications (Rating, ESRBRating, etc.)
  - `Protocols/` - Shared protocols
- Enhanced NetworkError with more specific cases
  - `.notFound` - 404 errors
  - `.rateLimitExceeded(retryAfter:)` - Rate limiting with retry info
  - `.noInternetConnection` - Connection errors
  - `.timeout` - Request timeout
  - `.unknown(Error)` - Unexpected errors
- NetworkManager now handles rate limiting (429) with Retry-After header
- Improved error messages with recovery suggestions

### Improved
- Better code organization and maintainability
- Reduced API calls through caching
- Enhanced error handling and user feedback
- Clearer model organization

## [1.0]

### Added
- Complete SDK for RAWG Video Games Database API
- 30+ endpoints covering all major API resources
- Type-safe models with Codable and Sendable support
- Fluent query builder for complex game searches
- Actor-based networking for thread-safety
- Comprehensive error handling
- Support for iOS 15+, macOS 13+, watchOS 8+, tvOS 15+
- 35 tests with Swift Testing framework (100% passing)
- SwiftLint integration for code quality
- SwiftFormat integration for consistent formatting
- CI/CD workflows for automated testing and releases
- Extensive documentation and examples

#### Core Client
- `RAWGClient` with async/await support
- Automatic API key injection
- Proper error handling with typed errors

#### Endpoints
- Games: list, details, screenshots, achievements, movies, reddit posts, DLC, series, parent games, development team
- Genres: list and details
- Platforms: list, details, and parent platforms
- Developers: list and details
- Publishers: list and details
- Stores: list and details
- Tags: list and details
- Creators: list, details, and roles

#### Models
- `Game` - Game information
- `GameDetails` - Extended game details
- `Genre` - Genre information
- `Platform` - Platform information
- `Store` - Store information
- `Creator` - Creator information
- `Achievement` - Game achievements
- `Movie` - Game trailers/videos
- `RedditPost` - Reddit discussions
- `RAWGResponse<T>` - Generic paginated response wrapper

#### Developer Tools
- SwiftLint for code style enforcement
- SwiftFormat for automatic code formatting
- CI workflow with linting, formatting, and testing
- Release workflow with automatic GitHub releases

[1.0]: https://github.com/pespinel/RAWGKit/releases/tag/v1.0
[1.1]: https://github.com/pespinel/RAWGKit/releases/tag/v1.1
[1.2]: https://github.com/pespinel/RAWGKit/releases/tag/v1.2
[2.0]: https://github.com/pespinel/RAWGKit/releases/tag/v2.0
[2.1]: https://github.com/pespinel/RAWGKit/releases/tag/v2.1
