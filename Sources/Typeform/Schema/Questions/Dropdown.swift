public struct Dropdown: Hashable, Sendable {
    public let choices: [Choice]
    public let description: String?
    public let randomize: Bool
    public let alphabeticalOrder: Bool

    @available(*, deprecated, renamed: "alphabeticalOrder")
    public var alphabetical_order: Bool { alphabeticalOrder }

    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        alphabeticalOrder: Bool = true,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        self.alphabeticalOrder = alphabeticalOrder
    }

    @available(*, deprecated, renamed: "init(choices:description:randomize:alphabeticalOrder:)")
    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        alphabetical_order: Bool,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        alphabeticalOrder = alphabetical_order
    }
}

extension Dropdown: Codable {
    enum CodingKeys: String, CodingKey {
        case choices
        case description
        case randomize
        case alphabeticalOrder = "alphabetical_order"
    }
}
