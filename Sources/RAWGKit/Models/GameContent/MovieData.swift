//
//  MovieData.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Contains movie/trailer URLs in different quality resolutions.
///
/// Provides access to video files optimized for different bandwidth requirements.
public struct MovieData: Codable, Hashable, Sendable {
    /// URL to the 480p quality video.
    public let size480: String?

    /// URL to the maximum quality video.
    public let max: String?

    /// Creates a new movie data instance.
    ///
    /// - Parameters:
    ///   - size480: URL to the 480p quality video.
    ///   - max: URL to the maximum quality video.
    public init(size480: String? = nil, max: String? = nil) {
        self.size480 = size480
        self.max = max
    }

    enum CodingKeys: String, CodingKey {
        case size480 = "480"
        case max
    }
}
