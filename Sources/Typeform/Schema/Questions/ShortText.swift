public struct ShortText: Hashable, Sendable {
    public let description: String?
    public let placeholder: String?

    public init(
        description: String? = nil,
        placeholder: String? = nil,
    ) {
        self.description = description
        self.placeholder = placeholder
    }
}

extension ShortText: Codable {
    enum CodingKeys: String, CodingKey {
        case description
        case placeholder = "placeholder_text"
    }
}
