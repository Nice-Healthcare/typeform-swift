public struct FileUpload: Hashable, Codable, Sendable {
    public let description: String?

    public init(description: String?) {
        self.description = description
    }
}
