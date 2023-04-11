import Foundation

public struct Logic: Hashable, Codable {
    
    public enum Kind: String, Codable {
        case field
    }
    
    public let ref: Reference
    public let type: Kind
    public let actions: [Action]
    
    public init(
        ref: Reference = .init(),
        type: Kind = .field,
        actions: [Action] = []
    ) {
        self.ref = ref
        self.type = type
        self.actions = actions
    }
}
