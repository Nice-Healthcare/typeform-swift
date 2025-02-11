import Foundation

public enum Op: String, Codable {
    case always
    case and
    case beginsWith = "begins_with"
    case contains
    case earlierThan = "earlier_than"
    case earlierThanOrOn = "earlier_than_or_on"
    case endsWith = "ends_with"
    case equal
    case greaterEqualThan = "greater_equal_than"
    case greaterThan = "greater_than"
    case `is`
    case isNot = "is_not"
    case laterThan = "later_than"
    case laterThanOrOn = "later_than_or_on"
    case lowerEqualThan = "lower_equal_than"
    case lowerThan = "lower_than"
    case notContains = "not_contains"
    case notOn = "not_on"
    case on
    case or
}

extension Op {
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func compareString(response: String, to condition: String) throws -> Bool {
        switch self {
        case .beginsWith: response.hasPrefix(condition)
        case .contains: response.contains(condition)
        case .endsWith: response.hasSuffix(condition)
        case .equal: response == condition
        case .notContains: !response.contains(condition)
        default:
            throw TypeformError.unexpectedOperation(self)
        }
    }

    func compareInt(response: Int, to condition: Int) throws -> Bool {
        switch self {
        case .equal:
            return response == condition
        case .greaterThan:
            return response > condition
        case .greaterEqualThan:
            return response >= condition
        case .lowerEqualThan:
            return response <= condition
        case .lowerThan:
            return response < condition
        default:
            throw TypeformError.unexpectedOperation(self)
        }
    }

    func compareDate(response: Date, to condition: String) throws -> Bool {
        guard let conditionDate = Self.yearMonthDay.date(from: condition) else {
            throw TypeformError.responseTypeMismatch(Date.self)
        }

        let comparison = Calendar.current.compare(response, to: conditionDate, toGranularity: .day)

        switch self {
        case .earlierThan:
            return comparison == .orderedAscending
        case .earlierThanOrOn:
            return comparison == .orderedAscending || comparison == .orderedSame
        case .laterThan:
            return comparison == .orderedDescending
        case .laterThanOrOn:
            return comparison == .orderedDescending || comparison == .orderedSame
        case .notOn:
            return comparison != .orderedSame
        case .on:
            return comparison == .orderedSame
        default:
            throw TypeformError.unexpectedOperation(self)
        }
    }
}
