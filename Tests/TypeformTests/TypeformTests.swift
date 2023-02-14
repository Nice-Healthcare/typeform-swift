import XCTest
@testable import Typeform
@testable import TypeformPreview

/// Base class which initializes a form for which to test against.
class TypeformTests: XCTestCase {
    
    /// ISO8601 formatter that uses only the `.withInternetDateTime` option.
    ///
    /// Uses GMT timezone.
    private static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    /// `JSONDecoder` that expects instances of `Date` to be in iSO8601 (fractional seconds) format.
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ dateDecoder in
            let container = try dateDecoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            if let date = iso8601DateFormatter.date(from: rawValue) {
                return date
            }
            let context = DecodingError.Context(
                codingPath: dateDecoder.codingPath,
                debugDescription: "Could not decode `Date` with value '\(rawValue)'."
            )
            throw DecodingError.dataCorrupted(context)
        })
        return decoder
    }()
    
    private(set) var form: Form!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "MedicalIntake23", withExtension: "json"))
        let data = try Data(contentsOf: url)
        form = try Self.decoder.decode(Typeform.Form.self, from: data)
    }
}
