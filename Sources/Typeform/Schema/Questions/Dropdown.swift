import Foundation

public struct Dropdown: Hashable, Codable {
    public let choices: [Choice]
    public let description: String?
    public let randomize: Bool
    public let alphabetical_order: Bool

    public init(
        choices: [Choice] = [],
        description: String? = nil,
        randomize: Bool = false,
        alphabetical_order: Bool = true
    ) {
        self.choices = choices
        self.description = description
        self.randomize = randomize
        self.alphabetical_order = alphabetical_order
    }
}
