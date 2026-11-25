public struct PictureChoice: Hashable, Sendable {
    public let choices: [Choice]
    public let description: String?
    public let randomize: Bool
    public let allowMultipleSelection: Bool
    public let allowOtherChoice: Bool
    public let allowNoneOfTheAbove: Bool
    public let supersized: Bool
    public let showLabels: Bool

    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        allowMultipleSelection: Bool = false,
        allowOtherChoice: Bool = false,
        allowNoneOfTheAbove: Bool = false,
        supersized: Bool = false,
        showLabels: Bool = true,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        self.allowMultipleSelection = allowMultipleSelection
        self.allowOtherChoice = allowOtherChoice
        self.allowNoneOfTheAbove = allowNoneOfTheAbove
        self.supersized = supersized
        self.showLabels = showLabels
    }
}

extension PictureChoice: Codable {
    enum CodingKeys: String, CodingKey {
        case choices
        case description
        case randomize
        case allowMultipleSelection = "allow_multiple_selection"
        case allowOtherChoice = "allow_other_choice"
        case allowNoneOfTheAbove = "none_of_the_above"
        case supersized
        case showLabels = "show_labels"
    }
}
