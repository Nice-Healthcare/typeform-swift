import Foundation

public enum Op: String, Codable {
    case always
    case and
    case equal
    case `is`
    case isNot = "is_not"
    case or
}
