import Foundation

public struct Action: Hashable, Decodable {
    
    public enum Kind: String, Decodable {
        case jump
    }
    
    public struct Details: Hashable, Decodable {
        
        public enum ToType: String, Decodable {
            case field
            case ending = "thankyou"
        }
        
        public struct To: Hashable, Decodable {
            public let type: ToType
            public let value: Reference
        }
        
        public let to: To
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "action"
        case details
        case condition
    }
    
    public let type: Kind
    public let details: Details
    public let condition: Condition
}
