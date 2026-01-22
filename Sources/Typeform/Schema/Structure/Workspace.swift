import Foundation

public struct Workspace: Hashable, Codable, Sendable {
    public let href: URL

    public init(
        href: URL = URL(string: "https://www.typeform.com")!,
    ) {
        self.href = href
    }
}
