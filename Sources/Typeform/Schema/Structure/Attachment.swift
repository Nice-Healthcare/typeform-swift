import Foundation

@available(*, deprecated, renamed: "Attachment")
public typealias ScreenAttachment = Attachment

public struct Attachment: Hashable, Codable {

    public enum Kind: String, Codable {
        case image
        case video
    }

    public struct Properties: Hashable, Codable {
        public let description: String?

        public init(description: String? = nil) {
            self.description = description
        }
    }

    public let href: URL
    public let type: Kind
    public let properties: Properties?

    public init(
        href: URL = URL(string: "https://www.typeform.com")!,
        type: Kind = .image,
        properties: Properties? = nil
    ) {
        self.href = href
        self.type = type
        self.properties = properties
    }
}
