import Foundation

public struct Logic: Hashable, Decodable {
    
    public enum Kind: String, Decodable {
        case field
    }
    
    public let ref: Reference
    public let type: Kind
    public let actions: [Action]
}
