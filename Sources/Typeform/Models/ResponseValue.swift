import Foundation

public enum ResponseValue: Hashable, Codable, Sendable {
    case bool(Bool)
    case choice(Choice)
    case choices([Choice])
    case choicesByReference([Reference: [Choice]])
    case date(Date)
    case int(Int)
    case string(String)
    case upload(Upload)

    enum CodingKeys: String, CodingKey {
        case bool
        case choice
        case choices
        case choicesByReference
        case date
        case int
        case string
        case upload
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)

        guard let key = allKeys.popFirst(), allKeys.isEmpty else {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Invalid number of keys found, expected one.",
            )

            throw DecodingError.typeMismatch(ResponseValue.self, context)
        }

        switch key {
        case .bool:
            self = try ResponseValue.bool(container.decode(Bool.self, forKey: .bool))
        case .choice:
            self = try ResponseValue.choice(container.decode(Choice.self, forKey: .choice))
        case .choices:
            self = try ResponseValue.choices(container.decode([Choice].self, forKey: .choices))
        case .choicesByReference:
            self = try ResponseValue.choicesByReference(container.decode([Reference: [Choice]].self, forKey: .choicesByReference))
        case .date:
            self = try ResponseValue.date(container.decode(Date.self, forKey: .date))
        case .int:
            self = try ResponseValue.int(container.decode(Int.self, forKey: .int))
        case .string:
            self = try ResponseValue.string(container.decode(String.self, forKey: .string))
        case .upload:
            self = try ResponseValue.upload(container.decode(Upload.self, forKey: .upload))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .bool(let value):
            try container.encode(value, forKey: .bool)
        case .choice(let value):
            try container.encode(value, forKey: .choice)
        case .choices(let value):
            try container.encode(value, forKey: .choices)
        case .choicesByReference(let value):
            try container.encode(value, forKey: .choicesByReference)
        case .date(let value):
            try container.encode(value, forKey: .date)
        case .int(let value):
            try container.encode(value, forKey: .int)
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .upload(let value):
            try container.encode(value, forKey: .upload)
        }
    }
}
