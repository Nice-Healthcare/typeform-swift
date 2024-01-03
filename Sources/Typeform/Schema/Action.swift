import Foundation

public struct Action: Hashable, Codable {
    
    public enum Kind: String, Codable {
        case jump
    }
    
    public struct Details: Hashable, Codable {
        
        public enum ToType: String, Codable {
            case field
            case ending = "thankyou"
        }
        
        // swiftlint:disable type_name
        public struct To: Hashable, Codable {
            public let type: ToType
            public let value: Reference
            
            public init(
                type: ToType = .field,
                value: Reference = Reference()
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
        // swiftlint:enable type_name
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
