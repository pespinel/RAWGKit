//
// RatingBadgeView.swift
// RAWGKit
//
// Created by RAWGKit on 10/12/2025.
//

#if canImport(SwiftUI)
    import SwiftUI

    /// A badge view that displays a game's rating with color-coded styling.
    ///
    /// The badge color changes based on the rating value:
    /// - Green: 4.0+
    /// - Yellow: 3.0-3.9
    /// - Orange: 2.0-2.9
    /// - Red: Below 2.0
    ///
    /// ## Usage
    /// ```swift
    /// HStack {
    ///     Text(game.name)
    ///     Spacer()
    ///     RatingBadgeView(rating: game.rating)
    /// }
    /// ```
    @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
    public struct RatingBadgeView: View {
        let rating: Double?

        /// Creates a new rating badge view.
        ///
        /// - Parameter rating: Optional rating value (0-5 scale).
        public init(rating: Double?) {
            self.rating = rating
        }

        public var body: some View {
            if let rating {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(ratingColor.opacity(0.2))
                .foregroundStyle(ratingColor)
                .clipShape(Capsule())
            }
        }

        private var ratingColor: Color {
            guard let rating else { return .gray }

            switch rating {
            case 4.0...:
                return .green
            case 3.0 ..< 4.0:
                return .yellow
            case 2.0 ..< 3.0:
                return .orange
            default:
                return .red
            }
        }
    }

    #if DEBUG
        @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
        struct RatingBadgeView_Previews: PreviewProvider {
            static var previews: some View {
                VStack(spacing: 12) {
                    RatingBadgeView(rating: 4.66)
                    RatingBadgeView(rating: 3.5)
                    RatingBadgeView(rating: 2.8)
                    RatingBadgeView(rating: 1.5)
                    RatingBadgeView(rating: nil)
                }
                .padding()
            }
        }
    #endif
#endif
