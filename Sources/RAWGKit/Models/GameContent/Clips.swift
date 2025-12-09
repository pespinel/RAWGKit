//
//  Clips.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Contains video clip URLs in different resolutions.
///
/// Provides access to clips optimized for different screen sizes and bandwidths.
public struct Clips: Codable, Sendable {
    /// URL to the 320p resolution clip.
    public let size320: String?

    /// URL to the 640p resolution clip.
    public let size640: String?

    /// URL to the full resolution clip.
    public let full: String?

    /// Creates a new clips instance.
    ///
    /// - Parameters:
    ///   - size320: URL to the 320p resolution clip.
    ///   - size640: URL to the 640p resolution clip.
    ///   - full: URL to the full resolution clip.
    public init(size320: String? = nil, size640: String? = nil, full: String? = nil) {
        self.size320 = size320
        self.size640 = size640
        self.full = full
    }

    enum CodingKeys: String, CodingKey {
        case size320 = "320"
        case size640 = "640"
        case full
    }
}
