import Foundation

public struct Dropdown: Hashable, Decodable {
    public let choices: [Choice]
    public let randomize: Bool
    public let alphabetical_order: Bool
    
    public init(
        choices: [Choice] = [],
        randomize: Bool = false,
        alphabetical_order: Bool = true
    ) {
        self.choices = choices
        self.randomize = randomize
        self.alphabetical_order = alphabetical_order
    }
}
