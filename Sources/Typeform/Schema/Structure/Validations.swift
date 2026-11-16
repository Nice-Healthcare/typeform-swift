public struct Validations: Hashable, Sendable {
    public let required: Bool
    public let maxLength: Int?
    public let regularExpression: String?

    public init(
        required: Bool = false,
        maxLength: Int? = nil,
        regularExpression: String? = nil,
    ) {
        self.required = required
        self.maxLength = maxLength
        self.regularExpression = regularExpression
    }
}

extension Validations: Codable {
    enum CodingKeys: String, CodingKey {
        case required
        case maxLength = "max_length"
        case regularExpression = "regexp"
    }
}
