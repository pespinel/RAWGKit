//
//  Clip.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a video clip associated with a game from the RAWG API.
///
/// Clips can include trailers, gameplay footage, or other promotional videos.
public struct Clip: Codable, Hashable, Sendable {
    /// URL to the main clip.
    public let clip: String?

    /// Collection of clip URLs in different resolutions.
    public let clips: Clips?

    /// URL to the video file.
    public let video: String?

    /// URL to the video preview/thumbnail.
    public let preview: String?

    /// Creates a new clip instance.
    ///
    /// - Parameters:
    ///   - clip: URL to the main clip.
    ///   - clips: Collection of clip URLs in different resolutions.
    ///   - video: URL to the video file.
    ///   - preview: URL to the video preview/thumbnail.
    public init(
        clip: String? = nil,
        clips: Clips? = nil,
        video: String? = nil,
        preview: String? = nil
    ) {
        self.clip = clip
        self.clips = clips
        self.video = video
        self.preview = preview
    }
}
