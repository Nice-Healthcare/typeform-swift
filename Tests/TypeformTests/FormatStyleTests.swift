#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import Testing
@testable import Typeform

struct FormatStyleTests {
    @Test func `Year Month Day - Date Formatting`() throws {
        let date = Date(timeIntervalSinceReferenceDate: 816_220_800)
        let formatted = date.formatted(.yearMonthDayDate)
        #expect(formatted == "2026-11-13")

        let raw = "2016-11-05"
        let parsed = try Date(raw, strategy: Date.ISO8601FormatStyle.yearMonthDayDate.parseStrategy)
        #expect(parsed.timeIntervalSinceReferenceDate == 499_996_800)
    }
}
