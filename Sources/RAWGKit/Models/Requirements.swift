/// System requirements for a platform
public struct Requirements: Codable, Hashable, Sendable {
    public let minimum: String?
    public let recommended: String?

    public init(minimum: String? = nil, recommended: String? = nil) {
        self.minimum = minimum
        self.recommended = recommended
    }
}