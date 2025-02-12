public struct FileUpload: Hashable, Codable {
    public let description: String?

    public init(description: String?) {
        self.description = description
    }
}
