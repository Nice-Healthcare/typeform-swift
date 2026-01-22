import Foundation

public struct WelcomeScreen: Screen, Hashable, Codable, Sendable {
    public let id: String
    public let ref: Reference
    public let title: String
    public let attachment: Attachment?
    public let properties: ScreenProperties

    public init(
        id: String = "",
        ref: Reference = "",
        title: String = "",
        attachment: Attachment? = nil,
        properties: ScreenProperties = ScreenProperties(),
    ) {
        self.id = id
        self.ref = ref
        self.title = title
        self.attachment = attachment
        self.properties = properties
    }
}
