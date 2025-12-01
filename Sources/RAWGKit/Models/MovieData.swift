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