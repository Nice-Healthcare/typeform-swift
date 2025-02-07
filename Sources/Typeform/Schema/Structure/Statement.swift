import Foundation

public struct Statement: Hashable, Codable {
    public let hide_marks: Bool
    public let button_text: String
    public let description: String?

    public init(
        hide_marks: Bool = false,
        button_text: String = "",
        description: String? = nil
    ) {
        self.hide_marks = hide_marks
        self.button_text = button_text
        self.description = description
    }
}
