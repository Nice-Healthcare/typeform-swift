import Foundation

public struct WelcomeScreen: Screen, Hashable, Codable {
    public let id: String
    public let ref: Reference
    public let title: String
    public let attachment: ScreenAttachment?
    public let properties: ScreenProperties
    
    public init(
        id: String = "",
        ref: Reference = Reference(),
        title: String = "",
        attachment: ScreenAttachment? = nil,
        properties: ScreenProperties = ScreenProperties()
    ) {
        self.id = id
        self.ref = ref
        self.title = title
        self.attachment = attachment
        self.properties = properties
    }
}
