import Foundation

public struct Var: Hashable, Decodable {
    
    public enum VarType: String, Decodable {
        case choice
        case constant
        case field
    }
    
    public enum Value: Hashable, Decodable {
        case bool(Bool)
        case ref(UUID)
        case string(String)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    public let type: VarType
    public let value: Value
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(VarType.self, forKey: .type)
        switch type {
        case .choice, .field:
            let ref = try container.decode(UUID.self, forKey: .value)
            value = .ref(ref)
        case .constant:
            if let bool = try? container.decode(Bool.self, forKey: .value) {
                value = .bool(bool)
            } else if let string = try? container.decode(String.self, forKey: .value) {
                value = .string(string)
            } else {
                let context = DecodingError.Context(codingPath: [CodingKeys.value], debugDescription: "Unknown `Var.value` for Type '\(type)'.")
                throw DecodingError.dataCorrupted(context)
            }
        }
    }
}
