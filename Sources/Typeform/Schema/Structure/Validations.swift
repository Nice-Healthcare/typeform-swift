public struct Validations: Hashable, Sendable {
    public let required: Bool
    public let maxLength: Int?
    public let maxValue: Int?
    public let minValue: Int?
    public let dateMin: String?
    public let dateMax: String?
    public let regularExpression: String?

    public init(
        required: Bool = false,
        maxLength: Int? = nil,
        maxValue: Int? = nil,
        minValue: Int? = nil,
        dateMin: String? = nil,
        dateMax: String? = nil,
        regularExpression: String? = nil,
    ) {
        self.required = required
        self.maxLength = maxLength
        self.maxValue = maxValue
        self.minValue = minValue
        self.dateMin = dateMin
        self.dateMax = dateMax
        self.regularExpression = regularExpression
    }
}

extension Validations: Codable {
    enum CodingKeys: String, CodingKey {
        case required
        case maxLength = "max_length"
        case maxValue = "max_value"
        case minValue = "min_value"
        case dateMin = "date_min"
        case dateMax = "date_max"
        case regularExpression = "regexp"
    }
}
