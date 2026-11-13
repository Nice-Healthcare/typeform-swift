#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension FormatStyle where Self == Date.ISO8601FormatStyle {
    /// A variant of the ISO 8601 Format Style which only represents
    /// year, month, and day values.
    ///
    /// - note: Example `2022-06-01`
    static var yearMonthDayDate: Date.ISO8601FormatStyle {
        .iso8601
            .year()
            .month()
            .day()
            .dateSeparator(.dash)
    }
}
