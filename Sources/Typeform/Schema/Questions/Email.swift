public struct Email: Hashable, Sendable {
    public let placeholder: String?
    
    public init(placeholder: String? = nil) {
        self.placeholder = placeholder
    }
}

extension Email: Codable {
    enum CodingKeys: String, CodingKey {
        case placeholder = "placeholder_text"
    }
}
