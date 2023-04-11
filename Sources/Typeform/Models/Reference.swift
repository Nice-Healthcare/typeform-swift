import Foundation

public struct Reference: Hashable, RawRepresentable, Codable {
    
    public var rawValue: UUID
    
    public var uuidString: String { rawValue.uuidString }
    
    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }
    
    public init?(uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            return nil
        }
        
        rawValue = uuid
    }
    
    public init() {
        rawValue = UUID()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(UUID.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
