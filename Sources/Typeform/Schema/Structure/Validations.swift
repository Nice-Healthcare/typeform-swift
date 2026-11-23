public struct Validations: Hashable, Sendable {
    public let required: Bool
    public let maxLength: Int?
    public let maxSelection: Int?
    public let minSelection: Int?
    public let maxValue: Int?
    public let minValue: Int?
    /// 'start' and 'end dates - either being fixed to a specific date or 'dynamic' relative to when the form is opened (today)
    public let dateMin: String?
    // TODO: Local Date or 'today'?
    public let dateMax: String?
    public let regularExpression: String?

    public init(
        required: Bool = false,
        maxLength: Int? = nil,
        maxSelection: Int? = nil,
        minSelection: Int? = nil,
        maxValue: Int? = nil,
        minValue: Int? = nil,
        dateMin: String? = nil,
        dateMax: String? = nil,
        regularExpression: String? = nil,
    ) {
        self.required = required
        self.maxLength = maxLength
        self.maxSelection = maxSelection
        self.minSelection = minSelection
        self.maxValue = maxValue
        self.minValue = minValue
        self.dateMin = dateMin
        self.dateMax = dateMax
        self.regularExpression = regularExpression
    }

    var regex: Regex<AnyRegexOutput>? {
        get throws {
            guard let regularExpression else {
                return nil
            }

            guard !regularExpression.isEmpty else {
                return nil
            }

            return try Regex(regularExpression)
        }
    }
}

extension Validations: Codable {
    enum CodingKeys: String, CodingKey {
        case required
        case maxLength = "max_length"
        case maxSelection = "max_selection"
        case minSelection = "min_selection"
        case maxValue = "max_value"
        case minValue = "min_value"
        case dateMin = "date_min"
        case dateMax = "date_max"
        case regularExpression = "regexp"
    }
}
