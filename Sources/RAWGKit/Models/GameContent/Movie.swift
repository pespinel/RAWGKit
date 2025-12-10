//
// Movie.swift
// RAWGKit
//

import Foundation

/// Represents a game trailer or movie from the RAWG API.
///
/// Movies provide promotional or gameplay videos in various qualities.
public struct Movie: Codable, Identifiable, Hashable, Sendable {
    /// Unique identifier for the movie.
    public let id: Int

    /// Display name of the movie/trailer.
    public let name: String

    /// URL to the movie preview/thumbnail.
    public let preview: String?

    /// Movie data containing URLs for different quality options.
    public let data: MovieData?

    /// Creates a new movie instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the movie.
    ///   - name: Display name of the movie/trailer.
    ///   - preview: URL to the preview/thumbnail.
    ///   - data: Movie data with quality options.
    public init(
        id: Int,
        name: String,
        preview: String? = nil,
        data: MovieData? = nil
    ) {
        self.id = id
        self.name = name
        self.preview = preview
        self.data = data
    }
}
