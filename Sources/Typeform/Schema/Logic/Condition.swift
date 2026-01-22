import Foundation

public struct Condition: Hashable, Codable, Sendable {

    public enum Parameters: Hashable, Sendable {
        case vars([Var])
        case conditions([Condition])
    }

    enum CodingKeys: CodingKey {
        case op
        case vars
    }

    public let op: Op
    public let parameters: Parameters

    public init(
        op: Op = .equal,
        parameters: Parameters = .conditions([]),
    ) {
        self.op = op
        self.parameters = parameters
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        op = try container.decode(Op.self, forKey: .op)
        if let conditions = try? container.decode([Condition].self, forKey: .vars) {
            parameters = .conditions(conditions)
        } else {
            let vars = try container.decode([Var].self, forKey: .vars)
            parameters = .vars(vars)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(op, forKey: .op)
        switch parameters {
        case .vars(let vars):
            try container.encode(vars, forKey: .vars)
        case .conditions(let conditions):
            try container.encode(conditions, forKey: .vars)
        }
    }
}
