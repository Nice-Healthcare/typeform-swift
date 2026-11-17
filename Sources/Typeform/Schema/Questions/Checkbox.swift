public struct Checkbox: Hashable, Sendable, Codable {
    public let description: String?
    public let choices: [Choice]

    public init(
        description: String? = nil,
        choices: [Choice] = [],
    ) {
        self.description = description
        self.choices = choices
    }
}
