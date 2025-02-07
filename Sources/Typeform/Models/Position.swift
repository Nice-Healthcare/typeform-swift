/// A reference to a screen or field for which navigation is occurring.
public enum Position {
    case screen(any Screen)
    case field(Field, Group? = nil)

    public var title: String {
        switch self {
        case .screen(let screen):
            screen.title
        case .field(let field, _):
            field.title
        }
    }
}
