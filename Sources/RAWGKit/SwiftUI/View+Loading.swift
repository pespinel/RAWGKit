//
// View+Loading.swift
// RAWGKit
//
// Created by RAWGKit on 10/12/2025.
//

#if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 15.0, macOS 13.0, tvOS 15.0, watchOS 8.0, *)
    public extension View {
        /// Displays a loading overlay when the condition is true.
        ///
        /// Use this modifier to show a centered loading indicator over your view.
        ///
        /// ## Usage
        /// ```swift
        /// List(viewModel.games) { game in
        ///     GameRow(game: game)
        /// }
        /// .showLoading(viewModel.isLoading && viewModel.games.isEmpty)
        /// ```
        ///
        /// - Parameter isLoading: Whether to show the loading indicator.
        /// - Returns: A view with an optional loading overlay.
        func showLoading(_ isLoading: Bool) -> some View {
            overlay {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5)
                            .tint(.white)
                    }
                }
            }
        }

        /// Displays an error alert when an error is present.
        ///
        /// Use this modifier to automatically show error alerts from NetworkError.
        ///
        /// ## Usage
        /// ```swift
        /// List(viewModel.games) { game in
        ///     GameRow(game: game)
        /// }
        /// .showError(error: viewModel.error) {
        ///     await viewModel.retry()
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - error: Optional NetworkError to display.
        ///   - retry: Optional retry action closure.
        /// - Returns: A view with error alert handling.
        func showError(
            error: NetworkError?,
            retry: (() async -> Void)? = nil
        ) -> some View {
            alert(
                "Error",
                isPresented: .constant(error != nil),
                presenting: error
            ) { _ in
                if let retry {
                    Button("Retry") {
                        Task { await retry() }
                    }
                }
                Button("OK", role: .cancel) {}
            } message: { error in
                Text(error.localizedDescription)
            }
        }

        /// Displays an empty state view when the condition is true.
        ///
        /// Use this modifier to show a placeholder when lists are empty.
        ///
        /// ## Usage
        /// ```swift
        /// List(viewModel.games) { game in
        ///     GameRow(game: game)
        /// }
        /// .showEmptyState(
        ///     viewModel.games.isEmpty && !viewModel.isLoading,
        ///     message: "No games found"
        /// )
        /// ```
        ///
        /// - Parameters:
        ///   - isEmpty: Whether the empty state should be shown.
        ///   - message: The message to display.
        ///   - systemImage: Optional SF Symbol name.
        /// - Returns: A view with empty state handling.
        func showEmptyState(
            _ isEmpty: Bool,
            message: String,
            systemImage: String = "questionmark.circle"
        ) -> some View {
            overlay {
                if isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: systemImage)
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text(message)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
#endif
