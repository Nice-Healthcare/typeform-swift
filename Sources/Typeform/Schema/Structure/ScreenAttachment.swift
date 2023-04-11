import Foundation

public struct ScreenAttachment: Hashable, Codable {
    public let href: URL
    public let type: String
    
    public init(
        href: URL = URL(string: "https://www.typeform.com")!,
        type: String = ""
    ) {
        self.href = href
        self.type = type
    }
}
