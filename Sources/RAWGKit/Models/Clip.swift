/// Video clip
public struct Clip: Codable, Sendable {
    public let clip: String?
    public let clips: Clips?
    public let video: String?
    public let preview: String?

    public init(
        clip: String? = nil,
        clips: Clips? = nil,
        video: String? = nil,
        preview: String? = nil
    ) {
        self.clip = clip
        self.clips = clips
        self.video = video
        self.preview = preview
    }
}