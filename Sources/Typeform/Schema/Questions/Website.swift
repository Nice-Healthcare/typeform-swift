public struct Website: Hashable, Sendable, Codable {
    public let description: String?

    public init(
        description: String? = nil,
    ) {
        self.description = description
    }
}
