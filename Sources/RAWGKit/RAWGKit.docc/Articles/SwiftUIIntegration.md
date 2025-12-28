# SwiftUI Integration

Build beautiful game browsing experiences with RAWGKit's SwiftUI components and ViewModels.

## Overview

RAWGKit provides first-class SwiftUI support with ready-to-use ViewModels, UI components, and view modifiers. This guide shows you how to integrate RAWGKit into your SwiftUI applications.

## Using GamesViewModel

The ``GamesViewModel`` provides a complete state management solution for displaying games in your SwiftUI app.

### Basic Setup

```swift
import RAWGKit
import SwiftUI

struct GamesListView: View {
    @StateObject private var viewModel = GamesViewModel(
        client: RAWGClient(apiKey: "your-api-key")
    )

    var body: some View {
        NavigationView {
            List(viewModel.games) { game in
                GameRowView(game: game)
            }
            .navigationTitle("Games")
            .searchable(text: $viewModel.searchText)
            .refreshable {
                await viewModel.loadGames()
            }
            .task {
                await viewModel.loadGames()
            }
        }
    }
}
```

### Features

The ``GamesViewModel`` includes:
- **Automatic Loading States**: Tracks loading, loaded, and error states
- **Search with Debouncing**: 300ms debounce prevents excessive API calls
- **Pull-to-Refresh**: Built-in refresh support
- **Infinite Scrolling**: Load more games as users scroll
- **Filtering**: Filter by platforms, genres, and ordering
- **Error Handling**: Automatic retry support

### Search and Filtering

```swift
struct GamesListView: View {
    @StateObject private var viewModel = GamesViewModel(
        client: RAWGClient(apiKey: "your-api-key")
    )

    var body: some View {
        List {
            ForEach(viewModel.games) { game in
                GameRowView(game: game)
                    .onAppear {
                        // Load more when reaching the end
                        if game == viewModel.games.last && viewModel.canLoadMore {
                            Task {
                                await viewModel.loadMore()
                            }
                        }
                    }
            }
        }
        .searchable(text: $viewModel.searchText)
        .toolbar {
            ToolbarItem {
                Menu("Filters") {
                    Picker("Platform", selection: $viewModel.selectedPlatform) {
                        Text("All").tag(Optional<Int>.none)
                        Text("PC").tag(Optional(4))
                        Text("PlayStation 5").tag(Optional(187))
                        Text("Xbox Series X/S").tag(Optional(186))
                    }

                    Picker("Genre", selection: $viewModel.selectedGenre) {
                        Text("All").tag(Optional<Int>.none)
                        Text("Action").tag(Optional(4))
                        Text("RPG").tag(Optional(5))
                        Text("Adventure").tag(Optional(3))
                    }

                    Picker("Order By", selection: $viewModel.ordering) {
                        Text("Rating").tag("-rating")
                        Text("Release Date").tag("-released")
                        Text("Name").tag("name")
                    }
                }
            }
        }
    }
}
```

## Pre-Built Components

### GameRowView

Display game information in a list row:

```swift
import RAWGKit
import SwiftUI

List(games) { game in
    GameRowView(game: game)
}
```

The ``GameRowView`` includes:
- Game image with async loading
- Game name and rating
- Release date
- Platform icons

### GameImageView

Display game images with placeholder and error handling:

```swift
GameImageView(
    url: game.backgroundImage,
    aspectRatio: 16/9,
    cornerRadius: 8
)
```

Features:
- Async image loading
- Placeholder while loading
- Error state handling
- Customizable aspect ratio and corner radius

### RatingBadgeView

Display color-coded rating badges:

```swift
RatingBadgeView(rating: game.rating)
```

The badge color automatically adjusts based on the rating:
- Green: 4.0+
- Orange: 3.0-3.9
- Red: Below 3.0
- Gray: No rating

## View Modifiers

### Loading Indicator

```swift
struct MyView: View {
    @State private var isLoading = false

    var body: some View {
        List {
            // Content
        }
        .showLoading(isLoading)
    }
}
```

### Error Display

```swift
struct MyView: View {
    @State private var error: NetworkError?

    var body: some View {
        List {
            // Content
        }
        .showError(error: error) {
            // Retry action
            await loadData()
        }
    }
}
```

### Empty State

```swift
struct MyView: View {
    var games: [Game]

    var body: some View {
        List(games) { game in
            GameRowView(game: game)
        }
        .showEmptyState(
            games.isEmpty,
            message: "No games found",
            systemImage: "magnifyingglass"
        )
    }
}
```

## Complete Example

Here's a complete example combining all features:

```swift
import RAWGKit
import SwiftUI

struct GamesListView: View {
    @StateObject private var viewModel = GamesViewModel(
        client: RAWGClient(apiKey: "your-api-key")
    )

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.games) { game in
                    NavigationLink(destination: GameDetailView(gameId: game.id)) {
                        GameRowView(game: game)
                    }
                    .onAppear {
                        if game == viewModel.games.last && viewModel.canLoadMore {
                            Task {
                                await viewModel.loadMore()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Games")
            .searchable(text: $viewModel.searchText, prompt: "Search games")
            .refreshable {
                await viewModel.loadGames()
            }
            .showLoading(viewModel.isLoading)
            .showError(error: viewModel.error) {
                await viewModel.retry()
            }
            .showEmptyState(
                viewModel.games.isEmpty && !viewModel.isLoading,
                message: "No games found",
                systemImage: "magnifyingglass"
            )
            .toolbar {
                ToolbarItem {
                    filterMenu
                }
            }
            .task {
                await viewModel.loadGames()
            }
        }
    }

    private var filterMenu: some View {
        Menu("Filters") {
            Picker("Platform", selection: $viewModel.selectedPlatform) {
                Text("All Platforms").tag(Optional<Int>.none)
                Text("PC").tag(Optional(4))
                Text("PlayStation 5").tag(Optional(187))
                Text("Xbox Series X/S").tag(Optional(186))
                Text("Nintendo Switch").tag(Optional(7))
            }

            Picker("Genre", selection: $viewModel.selectedGenre) {
                Text("All Genres").tag(Optional<Int>.none)
                Text("Action").tag(Optional(4))
                Text("RPG").tag(Optional(5))
                Text("Adventure").tag(Optional(3))
                Text("Shooter").tag(Optional(2))
            }

            Picker("Order By", selection: $viewModel.ordering) {
                Text("Rating").tag("-rating")
                Text("Release Date").tag("-released")
                Text("Name").tag("name")
                Text("Metacritic").tag("-metacritic")
            }
        }
    }
}
```

## Demo Application

For a complete, production-ready example, check out the included demo app at `Examples/RAWGKitDemo/`. It demonstrates:

- Complete game browsing interface
- Search and filtering
- Infinite scrolling
- Pull-to-refresh
- Error handling
- Dark mode support
- Secure API key configuration with `.xcconfig`

## Next Steps

- Explore <doc:AdvancedFeatures> for complex queries and pagination
- Learn about <doc:Performance> optimization techniques
- Review <doc:Security> best practices
