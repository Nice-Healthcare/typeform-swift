public struct DateStamp: Hashable, Codable, Sendable {

    public enum Separator: String, Sendable, Codable {
        case forwardSlash = "/"
        case dash = "-"
        case period = "."
    }

    public enum Structure: String, Sendable, Codable {
        case monthDayYear = "MMDDYYYY"
        case dayMonthYear = "DDMMYYYY"
        case yearMonthDay = "YYYYMMDD"
    }

    public let separator: Separator
    public let structure: Structure
    public let description: String?

    public init(
        separator: Separator = .forwardSlash,
        structure: Structure = .monthDayYear,
        description: String? = nil,
    ) {
        self.separator = separator
        self.structure = structure
        self.description = description
    }

    @available(*, deprecated)
    public init(
        separator: String = "",
        structure: String = "",
        description: String? = nil,
    ) {
        self.separator = Separator(rawValue: separator) ?? .forwardSlash
        self.structure = Structure(rawValue: structure) ?? .monthDayYear
        self.description = description
    }
}
