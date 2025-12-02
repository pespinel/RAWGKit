# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
