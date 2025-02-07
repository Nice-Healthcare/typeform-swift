import Foundation

public struct Rating: Hashable, Codable {
    public let shape: String
    public let steps: Int
    public let description: String?

    public init(
        shape: String = "",
        steps: Int = 0,
        description: String? = nil
    ) {
        self.shape = shape
        self.steps = steps
        self.description = description
    }
}
