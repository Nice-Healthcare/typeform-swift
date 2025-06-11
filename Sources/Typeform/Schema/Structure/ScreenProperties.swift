import Foundation

public struct ScreenProperties: Hashable, Codable, Sendable {
    public let button_mode: String?
    public let button_text: String?
    public let share_icons: Bool?
    public let show_button: Bool

    public init(
        button_mode: String? = nil,
        button_text: String? = nil,
        share_icons: Bool? = nil,
        show_button: Bool = false
    ) {
        self.button_mode = button_mode
        self.button_text = button_text
        self.share_icons = share_icons
        self.show_button = show_button
    }
}
