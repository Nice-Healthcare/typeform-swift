import Foundation

public struct Condition: Hashable, Decodable {
    
    public enum Parameters: Hashable, Decodable {
        case vars([Var])
        case conditions([Condition])
    }
    
    public let op: Op
    public let parameters: Parameters
    
    enum CodingKeys: CodingKey {
        case op
        case vars
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        op = try container.decode(Op.self, forKey: .op)
        if let conditions = try? container.decode([Condition].self, forKey: .vars) {
            parameters = .conditions(conditions)
        } else {
            let vars = try container.decode([Var].self, forKey: .vars)
            parameters = .vars(vars)
        }
    }
}
