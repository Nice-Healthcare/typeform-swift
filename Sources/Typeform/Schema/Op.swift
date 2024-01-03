import Foundation

// swiftlint:disable type_name
public enum Op: String, Codable {
    case always
    case and
    case equal
    case `is`
    case isNot = "is_not"
    case or
}
// swiftlint:enable type_name
