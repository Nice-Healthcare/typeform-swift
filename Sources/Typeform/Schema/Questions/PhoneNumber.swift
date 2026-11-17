public struct PhoneNumber: Hashable, Sendable {
    public let defaultCountryCode: String

    public init(defaultCountryCode: String = "US") {
        self.defaultCountryCode = defaultCountryCode
    }
}

extension PhoneNumber: Codable {
    enum CodingKeys: String, CodingKey {
        case defaultCountryCode = "default_country_code"
    }
}
