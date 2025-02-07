import Foundation

public struct Group: Hashable, Codable {
    public let button_text: String
    public let fields: [Field]
    public let show_button: Bool

    public init(
        button_text: String = "",
        fields: [Field] = [],
        show_button: Bool = false
    ) {
        self.button_text = button_text
        self.fields = fields
        self.show_button = show_button
    }
}
