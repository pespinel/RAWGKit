# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
