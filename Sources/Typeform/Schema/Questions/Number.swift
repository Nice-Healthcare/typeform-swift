import Foundation

public struct Number: Hashable, Codable {
    public let description: String?

    public init(
        description: String? = nil
    ) {
        self.description = description
    }
}
