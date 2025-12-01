/// Video clips in different sizes
public struct Clips: Codable, Sendable {
    public let size320: String?
    public let size640: String?
    public let full: String?

    public init(size320: String? = nil, size640: String? = nil, full: String? = nil) {
        self.size320 = size320
        self.size640 = size640
        self.full = full
    }

    enum CodingKeys: String, CodingKey {
        case size320 = "320"
        case size640 = "640"
        case full
    }
}