# RAWGKit

[![CI](https://github.com/pespinel/RAWGKit/actions/workflows/ci.yml/badge.svg)](https://github.com/pespinel/RAWGKit/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/pespinel/RAWGKit/branch/main/graph/badge.svg)](https://codecov.io/gh/pespinel/RAWGKit)
[![Swift Version](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS-blue.svg)](https://developer.apple.com)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modern, Swift-native SDK for the RAWG Video Games Database API with first-class SwiftUI support.

## 📚 Documentation

**[Read the complete documentation →](https://pespinel.github.io/RAWGKit/documentation/rawgkit/)**

Comprehensive guides including:
- Getting Started
- SwiftUI Integration
- Advanced Features (Query Builder, Pagination, AsyncSequence)
- Security Best Practices
- Performance Optimization
- Complete API Reference

## Features

- 🎨 **SwiftUI First-Class** - Ready-to-use ViewModels and UI components
- ✅ **Complete API Coverage** - All RAWG endpoints (games, platforms, genres, stores, creators)
- 🔒 **Type-Safe** - Fully typed with Codable models and compile-time safe filters
- ⚡ **Modern Swift** - Built with async/await and AsyncSequence
- 🎯 **Actor-Based** - Thread-safe networking with request deduplication
- 📱 **Cross-Platform** - iOS 15+, macOS 13+, watchOS 8+, tvOS 15+, visionOS 1+
- 🔨 **Fluent Query Builder** - Type-safe API with enums
- 🔄 **Auto-Pagination** - Stream results with AsyncSequence
- 💾 **Smart Caching** - In-memory with TTL
- 🔁 **Automatic Retries** - Exponential backoff
- 🔐 **Security** - Certificate pinning, Keychain storage, input validation

## Requirements

- Swift 6.0+
- iOS 15.0+ / macOS 13.0+ / watchOS 8.0+ / tvOS 15.0+ / visionOS 1.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pespinel/RAWGKit", from: "3.2.0")
]
```

Or in Xcode: **File → Add Packages...** and enter `https://github.com/pespinel/RAWGKit`

## Quick Start

### Get Your API Key

1. Visit [https://rawg.io/apidocs](https://rawg.io/apidocs)
2. Create an account and get your free API key

### Basic Usage

```swift
import RAWGKit

let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")

// Fetch popular games
let games = try await client.fetchGames(pageSize: 10, ordering: "-rating")
for game in games.results {
    print("\(game.name) - Rating: \(game.rating)")
}
```

### SwiftUI Example

```swift
import RAWGKit
import SwiftUI

struct GamesListView: View {
    @StateObject private var viewModel = GamesViewModel(
        client: RAWGClient(apiKey: "YOUR_API_KEY_HERE")
    )

    var body: some View {
        List(viewModel.games) { game in
            GameRowView(game: game)
        }
        .searchable(text: $viewModel.searchText)
        .task { await viewModel.loadGames() }
    }
}
```

### Query Builder

```swift
let response = try await client.gamesQuery()
    .search("witcher")
    .platforms([.pc, .playStation5])
    .genres([.rpg, .action])
    .metacriticMin(80)
    .orderByRating()
    .execute(with: client)
```

## Examples

Check out the [Examples/](Examples/) directory:
- **[BasicUsage.swift](Examples/BasicUsage.swift)** - Client setup, searching, error handling, caching
- **[AdvancedQueries.swift](Examples/AdvancedQueries.swift)** - Query builder, filtering, date ranges
- **[AsyncSequences.swift](Examples/AsyncSequences.swift)** - Streaming datasets, pagination
- **[RAWGKitDemo/](Examples/RAWGKitDemo/)** - Full SwiftUI demo app

## Testing & Quality

- ✅ **389 tests passing** - Comprehensive test coverage
- ✅ **SwiftLint strict mode** - Code quality enforcement
- ✅ **SwiftFormat** - Automated formatting
- ✅ **Strict Concurrency** - Maximum safety
- ✅ **CI/CD** - Automated testing on macOS

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Quick start for contributors:
```bash
make setup       # Install tools and git hooks
make test        # Run tests
make pre-commit  # Format, lint, and test
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Data provided by [RAWG.io](https://rawg.io)
- Built with Swift 6.0 and modern concurrency

## Support

- 📚 [Full Documentation](https://pespinel.github.io/RAWGKit/documentation/rawgkit/)
- 🐛 [Report Issues](https://github.com/pespinel/RAWGKit/issues)
- 💡 [Feature Requests](https://github.com/pespinel/RAWGKit/issues/new/choose)
- 📖 [RAWG API Docs](https://api.rawg.io/docs/)
