import Foundation
@testable import RAWGKit
import Testing

// Note: These tests verify SwiftUI component compilation on supported platforms.
// Due to Swift Testing limitations with @available + @MainActor in Swift 6,
// comprehensive UI tests are conducted through the RAWGKitDemo app.

#if canImport(SwiftUI) && (os(iOS) || os(macOS) || os(tvOS) || os(watchOS))
    import SwiftUI

    @Suite("SwiftUI Compilation Tests")
    struct SwiftUICompilationTests {
        // MARK: - GameImageView Compilation Tests

        @Test("GameImageView compiles with URL")
        func gameImageViewCompilation() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = GameImageView(url: "https://example.com/image.jpg")
                }
            }
        }

        @Test("GameImageView compiles with nil URL")
        func gameImageViewNilURL() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = GameImageView(url: nil)
                }
            }
        }

        @Test("GameImageView compiles with custom parameters")
        func gameImageViewCustomParams() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = GameImageView(url: "https://example.com/image.jpg", aspectRatio: 1.0, cornerRadius: 8.0)
                }
            }
        }

        // MARK: - RatingBadgeView Compilation Tests

        @Test("RatingBadgeView compiles with rating")
        func ratingBadgeViewCompilation() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = RatingBadgeView(rating: 4.5)
                }
            }
        }

        @Test("RatingBadgeView compiles with nil rating")
        func ratingBadgeViewNilRating() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = RatingBadgeView(rating: nil)
                }
            }
        }

        // MARK: - GameRowView Compilation Tests

        @Test("GameRowView compiles with game")
        func gameRowViewCompilation() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    let game = Game(
                        id: 1,
                        name: "Test Game",
                        slug: "test-game",
                        backgroundImage: "https://example.com/image.jpg",
                        released: "2023-05-15",
                        rating: 4.5
                    )
                    _ = GameRowView(game: game)
                }
            }
        }

        @Test("GameRowView compiles with minimal game")
        func gameRowViewMinimalGame() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    let game = Game(
                        id: 1,
                        name: "Test Game",
                        slug: "test-game",
                        backgroundImage: nil,
                        released: nil,
                        rating: 0.0
                    )
                    _ = GameRowView(game: game)
                }
            }
        }

        // MARK: - View+Loading Extension Compilation Tests

        @Test("showLoading modifier compiles")
        func showLoadingCompilation() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = Text("Test").showLoading(true)
                    _ = Text("Test").showLoading(false)
                }
            }
        }

        @Test("showError modifier compiles")
        func showErrorCompilation() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = Text("Test").showError(error: nil)
                    _ = Text("Test").showError(error: .invalidURL)
                    _ = Text("Test").showError(error: .timeout) {}
                }
            }
        }

        @Test("showEmptyState modifier compiles")
        func showEmptyStateCompilation() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = Text("Test").showEmptyState(true, message: "No data")
                    _ = Text("Test").showEmptyState(false, message: "Empty", systemImage: "magnifyingglass")
                }
            }
        }

        @Test("Modifiers chain together")
        func modifiersChaining() async {
            if #available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *) {
                await MainActor.run {
                    _ = Text("Test")
                        .showLoading(false)
                        .showError(error: nil)
                        .showEmptyState(true, message: "No data")
                }
            }
        }
    }
#endif
