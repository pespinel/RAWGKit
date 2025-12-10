//
// GameRowView.swift
// RAWGKit
//
// Created by RAWGKit on 10/12/2025.
//

#if canImport(SwiftUI)
    import SwiftUI

    /// A reusable row view for displaying game information in lists.
    ///
    /// `GameRowView` provides a consistent, appealing layout for games with
    /// thumbnail, title, rating, release date, and platform information.
    ///
    /// ## Usage
    /// ```swift
    /// List(viewModel.games) { game in
    ///     GameRowView(game: game)
    ///         .onTapGesture {
    ///             selectedGame = game
    ///         }
    /// }
    /// ```
    @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
    public struct GameRowView: View {
        let game: Game

        /// Creates a new game row view.
        ///
        /// - Parameter game: The game to display.
        public init(game: Game) {
            self.game = game
        }

        public var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // Thumbnail
                GameImageView(url: game.backgroundImage, aspectRatio: 1)
                    .frame(width: 80, height: 80)

                // Content
                VStack(alignment: .leading, spacing: 6) {
                    // Title
                    Text(game.name)
                        .font(.headline)
                        .lineLimit(2)

                    // Rating
                    if game.rating > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", game.rating))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Release date
                    if let released = game.released {
                        Text(released)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Platforms
                    if let platforms = game.platforms, !platforms.isEmpty {
                        Text(game.platformNames)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
        }
    }

    #if DEBUG
        @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
        struct GameRowView_Previews: PreviewProvider {
            static var previews: some View {
                List {
                    GameRowView(game: .mock)
                    GameRowView(game: .mockMinimal)
                }
            }
        }

        extension Game {
            static let mock = Game(
                id: 3328,
                name: "The Witcher 3: Wild Hunt",
                slug: "the-witcher-3-wild-hunt",
                backgroundImage: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg",
                released: "2015-05-18",
                rating: 4.66,
                ratingTop: 5,
                ratingsCount: 10000,
                metacritic: 92,
                playtime: 40,
                platforms: [
                    .init(platform: .init(id: 4, name: "PC", slug: "pc")),
                    .init(platform: .init(id: 187, name: "PlayStation 5", slug: "playstation5")),
                    .init(platform: .init(id: 1, name: "Xbox One", slug: "xbox-one")),
                ],
                genres: nil,
                tags: nil
            )

            static let mockMinimal = Game(
                id: 1,
                name: "Test Game",
                slug: "test-game",
                backgroundImage: nil,
                released: nil,
                rating: 0.0,
                ratingTop: nil,
                ratingsCount: nil,
                metacritic: nil,
                playtime: nil,
                platforms: nil,
                genres: nil,
                tags: nil
            )
        }
    #endif
#endif
