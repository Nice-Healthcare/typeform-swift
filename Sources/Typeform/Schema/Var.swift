import Foundation

public struct Var: Hashable, Codable, Sendable {

    public enum VarType: String, Codable, Sendable {
        case choice
        case constant
        case field
    }

    public enum Value: Hashable, Codable, Sendable {
        case bool(Bool)
        case ref(Reference)
        case string(String)
        case int(Int)
    }

    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    public let type: VarType
    public let value: Value

    public init(
        type: VarType = .constant,
        value: Value = .bool(false)
    ) {
        self.type = type
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(VarType.self, forKey: .type)
        switch type {
        case .choice, .field:
            let ref = try container.decode(Reference.self, forKey: .value)
            value = .ref(ref)
        case .constant:
            if let bool = try? container.decode(Bool.self, forKey: .value) {
                value = .bool(bool)
            } else if let int = try? container.decode(Int.self, forKey: .value) {
                value = .int(int)
            } else if let string = try? container.decode(String.self, forKey: .value) {
                value = .string(string)
            } else {
                let context = DecodingError.Context(codingPath: [CodingKeys.value], debugDescription: "Unknown `Var.value` for Type '\(type)'.")
                throw DecodingError.dataCorrupted(context)
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        switch value {
        case .ref(let reference):
            try container.encode(reference, forKey: .value)
        case .bool(let bool):
            try container.encode(bool, forKey: .value)
        case .string(let string):
            try container.encode(string, forKey: .value)
        case .int(let int):
            try container.encode(int, forKey: .value)
        }
    }
}
