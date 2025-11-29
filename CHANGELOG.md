# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-29

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

### Features

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

## [Unreleased]

### Planned
- Caching layer for reduced API calls
- Offline mode support
- Rate limiting handling
- Combine/RxSwift wrappers
- DocC documentation site

[1.0.0]: https://github.com/pespinel/RAWGKit/releases/tag/v1.0.0
