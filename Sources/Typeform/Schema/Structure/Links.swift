import Foundation

public struct Links: Hashable, Codable, Sendable {
    public let display: URL

    public init(
        display: URL = URL(string: "https://www.typeform.com")!,
    ) {
        self.display = display
    }
}
