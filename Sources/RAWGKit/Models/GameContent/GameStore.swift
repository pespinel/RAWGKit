//
//  GameStore.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//


/// Game store link
public struct GameStore: Codable, Identifiable, Sendable {
    public let id: Int
    public let gameId: Int?
    public let storeId: Int?
    public let url: String?
    public let store: Store?

    public init(
        id: Int,
        gameId: Int? = nil,
        storeId: Int? = nil,
        url: String? = nil,
        store: Store? = nil
    ) {
        self.id = id
        self.gameId = gameId
        self.storeId = storeId
        self.url = url
        self.store = store
    }

    enum CodingKeys: String, CodingKey {
        case id, url, store
        case gameId = "game_id"
        case storeId = "store_id"
    }
}