import Foundation

public struct EndingScreen: Screen, Hashable, Codable, Sendable {

    public enum Ref: Hashable, Codable, Sendable {
        case `default`
        case ref(Reference)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let reference = try container.decode(Reference.self)
            if case .string(let stringValue) = reference, stringValue == EndingScreen.defaultTYSKey {
                self = .default
            } else {
                self = .ref(reference)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .default:
                try container.encode(EndingScreen.defaultTYSKey)
            case .ref(let reference):
                try container.encode(reference)
            }
        }
    }

    public static let defaultTYSKey = "default_tys"

    public let id: String
    public let ref: Ref
    public let type: String
    public let title: String
    public let attachment: Attachment?
    public let properties: ScreenProperties

    public init(
        id: String = "",
        ref: Ref = .default,
        type: String = "thankyou_screen",
        title: String = "",
        attachment: Attachment? = nil,
        properties: ScreenProperties = ScreenProperties()
    ) {
        self.id = id
        self.ref = ref
        self.type = type
        self.title = title
        self.attachment = attachment
        self.properties = properties
    }

    /// The _default_ 'Thank You' screen.
    ///
    /// - note: A unique id of 'DefaultTyScreen' is used in place of a sudo-random string of other entities.
    public static var defaultThankYou: EndingScreen {
        EndingScreen(
            id: "DefaultTyScreen",
            ref: .default,
            type: "thankyou_screen",
            title: "All done!, Thanks for you time.",
            properties: ScreenProperties(
                share_icons: false,
                show_button: false
            )
        )
    }
}
