//
// ResourceProtocol.swift
// RAWGKit
//

import Foundation

/// Protocol for basic API resource information
public protocol BasicResource: Codable, Identifiable, Hashable, Sendable {
    var id: Int { get }
    var name: String { get }
    var slug: String { get }
}

/// Protocol for resources with image backgrounds
public protocol ImageResource: BasicResource {
    var imageBackground: String? { get }
}

/// Protocol for resources with game counts
public protocol GameCountResource: ImageResource {
    var gamesCount: Int? { get }
}

/// Protocol for detailed resource information
public protocol DetailedResource: BasicResource {
    var description: String? { get }
    var imageBackground: String? { get }
    var gamesCount: Int? { get }
}
