import Foundation

public enum Op: String, Codable {
    case always
    case and
    case equal
    case greaterEqualThan = "greater_equal_than"
    case greaterThan = "greater_than"
    case `is`
    case isNot = "is_not"
    case lowerEqualThan = "lower_equal_than"
    case lowerThan = "lower_than"
    case or
}
