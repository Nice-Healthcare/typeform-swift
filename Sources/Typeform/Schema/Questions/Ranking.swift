public struct Ranking: Hashable, Sendable {
    public let choices: [Choice]
    public let description: String?
    public let randomize: Bool
    public let allowMultipleSelection: Bool

    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        allowMultipleSelection: Bool = false,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        self.allowMultipleSelection = allowMultipleSelection
    }
}

extension Ranking: Codable {
    enum CodingKeys: String, CodingKey {
        case choices
        case description
        case randomize
        case allowMultipleSelection = "allow_multiple_selection"
    }
}
