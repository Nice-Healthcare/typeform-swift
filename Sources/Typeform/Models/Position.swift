/// A reference to a screen or field for which navigation is occurring.
public enum Position {
    case screen(any Screen)
    case field(Field, Group? = nil)
    
    public var title: String {
        switch self {
        case .screen(let screen):
            return screen.title
        case .field(let field, _):
            return field.title
        }
    }
}
