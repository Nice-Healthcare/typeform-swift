import Foundation

public struct Reference: Hashable, RawRepresentable, Codable {
    
    /// Controls the behavior of `Reference` encoding.
    ///
    /// By default, `JSONEncoder` will encode the underlying `UUID` in all uppercase characters.
    /// Since the **Typeform** api uses lowercased GUID for reference strings, the default encoding behavior is to match.
    public enum ValueEncodingCase {
        /// The system default behavior is used.
        case automatic
        /// The value will be encoded using only upper-case characters.
        case uppercase
        /// The value will be encoded using only lower-case characters.
        case lowercase
    }
    
    public static var valueEncodingCase: ValueEncodingCase = .lowercase
    
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
        switch Self.valueEncodingCase {
        case .automatic:
            try container.encode(rawValue)
        case .uppercase:
            try container.encode(rawValue.uuidString.uppercased())
        case .lowercase:
            try container.encode(rawValue.uuidString.lowercased())
        }
    }
}
