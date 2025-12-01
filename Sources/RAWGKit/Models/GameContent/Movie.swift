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
