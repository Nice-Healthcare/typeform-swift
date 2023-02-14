import XCTest
@testable import Typeform

final class ResponsesTests: TypeformTests {
    
    func testResponseJSON() {
        
    }
}

extension ResponseValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        switch self {
        case .bool(let value):
            try container.encode(value)
        case .choice(let value):
            try container.encode(value.ref.uuidString.lowercased())
        case .choices(let value):
            var choices = container.nestedContainer(keyedBy: DictionaryKeys.self)
            try value.forEach {
                try choices.encode(true, forKey: DictionaryKeys(stringValue: $0.ref.uuidString.lowercased()))
            }
        case .date(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode("\(value)")
        case .string(let value):
            try container.encode(value)
        }
    }
    
    struct DictionaryKeys: CodingKey {
        public var stringValue: String
        public var intValue: Int?
        
        public init(stringValue: String) {
            self.stringValue = stringValue
        }
        
        public init(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
}
