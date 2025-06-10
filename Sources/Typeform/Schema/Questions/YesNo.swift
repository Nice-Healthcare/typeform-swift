import Foundation

public struct YesNo: Hashable, Codable, Sendable {

    public let description: String?

    public init(
        description: String? = nil
    ) {
        self.description = description
    }
}
