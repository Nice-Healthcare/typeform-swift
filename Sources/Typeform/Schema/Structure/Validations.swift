import Foundation

public struct Validations: Hashable, Codable, Sendable {
    public let required: Bool

    public init(
        required: Bool = false,
    ) {
        self.required = required
    }
}
