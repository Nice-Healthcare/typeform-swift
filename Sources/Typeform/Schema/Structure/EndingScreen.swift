import Foundation

public struct EndingScreen: Screen, Hashable, Codable {
    
    public enum Ref: Hashable, Codable {
        case `default`
        case ref(Reference)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let ref = try? container.decode(Reference.self) {
                self = .ref(ref)
            } else {
                self = .default
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .`default`:
                try container.encodeNil()
            case .ref(let reference):
                try container.encode(reference)
            }
        }
    }
    
    public let id: String
    public let ref: Ref
    public let type: String
    public let title: String
    public let attachment: ScreenAttachment?
    public let properties: ScreenProperties
    
    public init(
        id: String = "",
        ref: Ref = .`default`,
        type: String = "",
        title: String = "",
        attachment: ScreenAttachment? = nil,
        properties: ScreenProperties = ScreenProperties()
    ) {
        self.id = id
        self.ref = ref
        self.type = type
        self.title = title
        self.attachment = attachment
        self.properties = properties
    }
}
