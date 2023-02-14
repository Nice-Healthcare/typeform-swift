import Foundation

public struct WelcomeScreen: Screen, Hashable, Decodable {
    public let id: String
    public let ref: UUID
    public let title: String
    public let attachment: ScreenAttachment?
    public let properties: ScreenProperties
}
