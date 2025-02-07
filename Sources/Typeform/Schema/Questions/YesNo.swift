import Foundation

public struct YesNo: Hashable, Codable {

    public let description: String?

    public init(
        description: String? = nil
    ) {
        self.description = description
    }
}
