import Foundation

public struct Choice: Hashable, Identifiable, Decodable {
    public let id: String
    public let ref: Reference
    public let label: String
    
    internal init(
        id: String = "",
        ref: Reference = Reference(),
        label: String = ""
    ) {
        self.id = id
        self.ref = ref
        self.label = label
    }
}
