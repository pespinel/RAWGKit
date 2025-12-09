//
//  GameStore.swift
//  RAWGKit
//
//  Created by Pablo Espinel on 30/11/25.
//

/// Represents a link to a game on a digital store platform.
///
/// Associates a game with a specific store and provides the purchase URL.
public struct GameStore: Codable, Identifiable, Sendable {
    /// Unique identifier for the game-store association.
    public let id: Int

    /// ID of the associated game.
    public let gameId: Int?

    /// ID of the associated store.
    public let storeId: Int?

    /// URL to the game's page on the store.
    public let url: String?

    /// Detailed information about the store.
    public let store: Store?

    /// Creates a new game store instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the association.
    ///   - gameId: ID of the associated game.
    ///   - storeId: ID of the associated store.
    ///   - url: URL to the game's store page.
    ///   - store: Detailed store information.
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
