/// Parent platform with child platforms
public struct ParentPlatform: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
    public let platforms: [Platform]?

    public init(
        id: Int,
        name: String,
        slug: String,
        platforms: [Platform]? = nil
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.platforms = platforms
    }
}