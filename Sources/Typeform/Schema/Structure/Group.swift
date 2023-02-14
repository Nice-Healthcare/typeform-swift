import Foundation

public struct Group: Hashable, Decodable {
    public let button_text: String
    public let fields: [Field]
    public let show_button: Bool
}
