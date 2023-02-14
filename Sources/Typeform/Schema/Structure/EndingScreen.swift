import Foundation

public struct EndingScreen: Screen, Hashable, Decodable {
    
    public enum Ref: Hashable, Decodable {
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
    }
    
    public let id: String
    public let ref: Ref
    public let type: String
    public let title: String
    public let attachment: ScreenAttachment?
    public let properties: ScreenProperties
}
