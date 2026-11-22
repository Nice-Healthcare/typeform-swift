public struct Dropdown: Hashable, Sendable {
    public let choices: [Choice]
    public let description: String?
    public let randomize: Bool
    public let alphabetical: Bool

    @available(*, deprecated, renamed: "alphabetical")
    public var alphabetical_order: Bool { alphabetical }

    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        alphabetical: Bool = true,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        self.alphabetical = alphabetical
    }

    @available(*, deprecated, renamed: "init(choices:description:randomize:alphabetical:)")
    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        alphabetical_order: Bool,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        alphabetical = alphabetical_order
    }
}

extension Dropdown: Codable {
    enum CodingKeys: String, CodingKey {
        case choices
        case description
        case randomize
        case alphabetical = "alphabetical_order"
    }
}
