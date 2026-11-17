public struct MultipleChoice: Hashable, Sendable {
    public let choices: [Choice]
    public let description: String?
    public let randomize: Bool
    public let allowMultipleSelection: Bool
    public let allowOtherChoice: Bool
    public let allowNoneOfTheAbove: Bool
    public let verticalAlignment: Bool

    @available(*, deprecated, renamed: "allowMultipleSelection")
    public var allow_multiple_selection: Bool { allowMultipleSelection }
    @available(*, deprecated, renamed: "allowOtherChoice")
    public var allow_other_choice: Bool { allowOtherChoice }
    @available(*, deprecated, renamed: "verticalAlignment")
    public var vertical_alignment: Bool { verticalAlignment }

    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        allowMultipleSelection: Bool = false,
        allowOtherChoice: Bool = false,
        allowNoneOfTheAbove: Bool = false,
        verticalAlignment: Bool = false,
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        self.allowMultipleSelection = allowMultipleSelection
        self.allowOtherChoice = allowOtherChoice
        self.allowNoneOfTheAbove = allowNoneOfTheAbove
        self.verticalAlignment = verticalAlignment
    }

    @available(*, deprecated, renamed: "init(choices:description:randomize:allowMultipleChoices:allowOtherChoice:allowNoneOfTheAbove:verticalAlignment:)")
    public init(
        choices: [Choice] = [],
        randomize: Bool = false,
        allow_multiple_selection: Bool = false,
        allow_other_choice: Bool = false,
        vertical_alignment: Bool = false,
        description: String? = nil,
    ) {
        self.choices = choices
        self.randomize = randomize
        allowMultipleSelection = allow_multiple_selection
        allowOtherChoice = allow_other_choice
        allowNoneOfTheAbove = false
        verticalAlignment = vertical_alignment
        self.description = description
    }
}

extension MultipleChoice: Codable {
    enum CodingKeys: String, CodingKey {
        case choices
        case description
        case randomize
        case allowMultipleSelection = "allow_multiple_selection"
        case allowOtherChoice = "allow_other_choice"
        case allowNoneOfTheAbove = "none_of_the_above"
        case verticalAlignment = "vertical_alignment"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        choices = try container.decode([Choice].self, forKey: .choices)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        randomize = try container.decode(Bool.self, forKey: .randomize)
        allowMultipleSelection = try container.decode(Bool.self, forKey: .allowMultipleSelection)
        allowOtherChoice = try container.decode(Bool.self, forKey: .allowOtherChoice)
        allowNoneOfTheAbove = try container.decodeIfPresent(Bool.self, forKey: .allowNoneOfTheAbove) ?? false
        verticalAlignment = try container.decode(Bool.self, forKey: .verticalAlignment)
    }
}
