import Foundation

public struct Validations: Hashable, Codable {
    public let required: Bool

    public init(
        required: Bool = false
    ) {
        self.required = required
    }
}
