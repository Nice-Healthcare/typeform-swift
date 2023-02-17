import Foundation

public struct ScreenProperties: Hashable, Decodable {
    public let button_mode: String?
    public let button_text: String?
    public let share_icons: Bool?
    public let show_button: Bool
}
