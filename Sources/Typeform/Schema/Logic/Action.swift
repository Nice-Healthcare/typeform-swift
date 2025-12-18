import Foundation

public struct Action: Hashable, Codable, Sendable {

    public enum Kind: String, Codable, Sendable {
        case jump
    }

    public struct Details: Hashable, Codable, Sendable {

        public enum ToType: String, Codable, Sendable {
            case field
            case ending = "thankyou"
        }

        public struct To: Hashable, Codable, Sendable {
            public let type: ToType
            public let value: Reference

            public init(
                type: ToType = .field,
                value: Reference = ""
            ) {
                self.type = type
                self.value = value
            }
        }

        public let to: To

        public init(
            to: To = To()
        ) {
            self.to = to
        }
    }

    enum CodingKeys: String, CodingKey {
        case type = "action"
        case details
        case condition
    }

    public let type: Kind
    public let details: Details
    public let condition: Condition

    public init(
        type: Kind = .jump,
        details: Details = Details(),
        condition: Condition = Condition()
    ) {
        self.type = type
        self.details = details
        self.condition = condition
    }
}
