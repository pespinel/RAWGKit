# ``RAWGKit``

A modern, Swift-native SDK for the RAWG Video Games Database API with first-class SwiftUI support.

## Overview

RAWGKit provides a comprehensive, type-safe Swift SDK for accessing the RAWG Video Games Database API. Built with modern Swift features like async/await, actors, and strict concurrency checking, it offers a robust and efficient way to integrate game data into your iOS, macOS, watchOS, tvOS, and visionOS applications.

### Key Features

- **Complete API Coverage**: Access all RAWG API endpoints for games, platforms, genres, developers, publishers, stores, tags, and creators
- **Type-Safe**: Fully typed responses with Codable models and compile-time safe query filters
- **Modern Swift**: Built with async/await and AsyncSequence for clean asynchronous code
- **Actor-Based**: Thread-safe networking with Swift's actor model and automatic request deduplication
- **SwiftUI Ready**: Pre-built ViewModels, components, and a complete demo application
- **Cross-Platform**: Supports iOS 15+, macOS 13+, watchOS 8+, tvOS 15+, and visionOS 1+
- **Smart Caching**: In-memory NSCache with TTL and automatic memory management
- **Automatic Retries**: Configurable retry policy with exponential backoff
- **Secure**: Certificate pinning, TLS enforcement, and Keychain storage for API keys

## Topics

### Getting Started

- <doc:GettingStarted>
- <doc:SwiftUIIntegration>

### Core Concepts

- ``RAWGClient``
- ``GamesQueryBuilder``
- ``NetworkManaging``

### Models

#### Core Models
- ``Game``
- ``GameDetails``
- ``RAWGResponse``

#### Resources
- ``Genre``
- ``Platform``
- ``Developer``
- ``Publisher``
- ``Store``
- ``Tag``
- ``Creator``

#### Game Content
- ``Screenshot``
- ``Movie``
- ``Achievement``
- ``RedditPost``

### Advanced Features

- <doc:AdvancedFeatures>
- <doc:Security>
- <doc:Performance>

### SwiftUI Components

- ``GamesViewModel``
- ``GameRowView``
- ``GameImageView``
- ``RatingBadgeView``

### Networking

- ``NetworkManager``
- ``RetryPolicy``
- ``CacheManager``
- ``NetworkError``

### Security

- ``KeychainManager``
- ``CertificatePinning``
- ``InputValidator``

### Utilities

- ``RAWGConstants``
- ``RAWGLogger``
