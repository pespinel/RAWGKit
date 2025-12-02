//
//  Screenshot.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

public struct Screenshot: Codable, Identifiable, Sendable {
    public let id: Int
    public let image: String
    public let width: Int?
    public let height: Int?
    public let isDeleted: Bool?

    public init(
        id: Int,
        image: String,
        width: Int? = nil,
        height: Int? = nil,
        isDeleted: Bool? = nil
    ) {
        self.id = id
        self.image = image
        self.width = width
        self.height = height
        self.isDeleted = isDeleted
    }

    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}
