import Foundation

public struct DateStamp: Hashable, Codable, Sendable {
    public let separator: String
    public let structure: String
    public let description: String?

    public init(
        separator: String = "",
        structure: String = "",
        description: String? = nil,
    ) {
        self.separator = separator
        self.structure = structure
        self.description = description
    }
}
