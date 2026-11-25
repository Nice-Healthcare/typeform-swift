public struct OpinionScale: Hashable, Sendable {

    public struct Labels: Hashable, Codable, Sendable {

        enum CodingKeys: String, CodingKey {
            case leading = "left"
            case center
            case trailing = "right"
        }

        public let leading: String?
        public let center: String?
        public let trailing: String?

        public init(
            leading: String? = nil,
            center: String? = nil,
            trailing: String? = nil,
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
        }
    }

    public let steps: Int
    public let labels: Labels?
    public let startAtOne: Bool

    @available(*, deprecated, renamed: "startAtOne")
    public var start_at_one: Bool { startAtOne }

    public init(
        steps: Int = 0,
        startAtOne: Bool = false,
        labels: Labels? = nil,
    ) {
        self.steps = steps
        self.startAtOne = startAtOne
        self.labels = labels
    }

    @available(*, deprecated, renamed: "init(steps:startAtOne:labels:)")
    public init(
        steps: Int = 0,
        labels: Labels? = nil,
        start_at_one: Bool = false,
    ) {
        self.steps = steps
        self.labels = labels
        startAtOne = start_at_one
    }
}

extension OpinionScale: Codable {
    enum CodingKeys: String, CodingKey {
        case steps
        case startAtOne = "start_at_one"
        case labels
    }
}
