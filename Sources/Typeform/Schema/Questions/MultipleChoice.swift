import Foundation

public struct MultipleChoice: Hashable, Codable {
    public let choices: [Choice]
    public let randomize: Bool
    public let allow_multiple_selection: Bool
    public let allow_other_choice: Bool
    public let vertical_alignment: Bool
    public let description: String?

    public init(
        choices: [Choice] = [],
        randomize: Bool = false,
        allow_multiple_selection: Bool = false,
        allow_other_choice: Bool = false,
        vertical_alignment: Bool = false,
        description: String? = nil
    ) {
        self.choices = choices
        self.randomize = randomize
        self.allow_multiple_selection = allow_multiple_selection
        self.allow_other_choice = allow_other_choice
        self.vertical_alignment = vertical_alignment
        self.description = description
    }
}
