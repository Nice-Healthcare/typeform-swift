public struct NetPromoterScore: Hashable, Sendable, Codable {
    public let description: String?
    public let steps: Int

    public init(
        description: String? = nil,
        steps: Int = 0,
    ) {
        self.description = description
        self.steps = steps
    }
}
