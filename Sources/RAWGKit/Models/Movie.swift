//
// Movie.swift
// RAWGKit
//

import Foundation

/// Game trailer/movie
public struct Movie: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let preview: String?
    public let data: MovieData?

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

/// Movie/trailer data with different quality options
public struct MovieData: Codable, Sendable {
    public let size480: String?
    public let max: String?

    public init(size480: String? = nil, max: String? = nil) {
        self.size480 = size480
        self.max = max
    }

    enum CodingKeys: String, CodingKey {
        case size480 = "480"
        case max
    }
}
