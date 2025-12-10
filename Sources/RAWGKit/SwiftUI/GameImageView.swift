//
// GameImageView.swift
// RAWGKit
//
// Created by RAWGKit on 10/12/2025.
//

#if canImport(SwiftUI)
    import SwiftUI

    /// A view that displays a game's background image with placeholder and error handling.
    ///
    /// `GameImageView` automatically handles loading states and provides a consistent
    /// appearance for game images throughout your app.
    ///
    /// ## Features
    /// - Async image loading
    /// - Automatic placeholder display
    /// - Error state with retry
    /// - Configurable aspect ratio
    /// - Rounded corners and shadow
    ///
    /// ## Usage
    /// ```swift
    /// GameImageView(
    ///     url: game.backgroundImage,
    ///     aspectRatio: 16/9
    /// )
    /// .frame(height: 200)
    /// ```
    @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
    public struct GameImageView: View {
        let url: String?
        let aspectRatio: CGFloat?
        let cornerRadius: CGFloat

        /// Creates a new game image view.
        ///
        /// - Parameters:
        ///   - url: The URL string of the image to load.
        ///   - aspectRatio: Optional aspect ratio (width/height).
        ///   - cornerRadius: Corner radius for the image. Defaults to 12.
        public init(
            url: String?,
            aspectRatio: CGFloat? = 16 / 9,
            cornerRadius: CGFloat = 12
        ) {
            self.url = url
            self.aspectRatio = aspectRatio
            self.cornerRadius = cornerRadius
        }

        public var body: some View {
            Group {
                if let urlString = url, let imageURL = URL(string: urlString) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            placeholderView
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(aspectRatio, contentMode: .fill)
                        case .failure:
                            errorView
                        @unknown default:
                            placeholderView
                        }
                    }
                } else {
                    placeholderView
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }

        private var placeholderView: some View {
            ZStack {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
            .aspectRatio(aspectRatio, contentMode: .fit)
        }

        private var errorView: some View {
            ZStack {
                Rectangle()
                    .fill(Color.red.opacity(0.1))
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
            }
            .aspectRatio(aspectRatio, contentMode: .fit)
        }
    }

    #if DEBUG
        @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
        struct GameImageView_Previews: PreviewProvider {
            static var previews: some View {
                VStack(spacing: 20) {
                    // Valid URL
                    GameImageView(
                        url: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"
                    )
                    .frame(height: 200)

                    // No URL
                    GameImageView(url: nil)
                        .frame(height: 200)

                    // Invalid URL
                    GameImageView(url: "invalid-url")
                        .frame(height: 200)
                }
                .padding()
            }
        }
    #endif
#endif
