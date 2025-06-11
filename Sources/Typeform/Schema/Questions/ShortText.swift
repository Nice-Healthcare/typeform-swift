import Foundation

public struct ShortText: Hashable, Codable, Sendable {
    public let description: String?

    public init(
        description: String? = nil
    ) {
        self.description = description
    }
}
