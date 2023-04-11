import Foundation

public struct Choice: Hashable, Identifiable, Codable {
    public let id: String
    public let ref: Reference
    public let label: String
    
    public init(
        id: String = "",
        ref: Reference = Reference(),
        label: String = ""
    ) {
        self.id = id
        self.ref = ref
        self.label = label
    }
}
