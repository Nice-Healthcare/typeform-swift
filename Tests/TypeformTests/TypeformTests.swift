import XCTest
@testable import Typeform
@testable import TypeformPreview

/// Base class which initializes a form for which to test against.
class TypeformTests: XCTestCase {
    
    /// Date formatter that uses the format **2023-03-57T10:30:23+00:00**.
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        return formatter
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ dateDecoder in
            let container = try dateDecoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            if let date = dateFormatter.date(from: rawValue) {
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
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom({ date, dateEncoder in
            var container = dateEncoder.singleValueContainer()
            try container.encode(dateFormatter.string(from: date))
        })
        return encoder
    }()
    
    /// `JSONEncoder` that encodes `Date` in an ISO8601 (with fractional seconds) format and outputs in a _pretty_ format.
    static let prettyEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .custom({ date, dateEncoder in
            var container = dateEncoder.singleValueContainer()
            try container.encode(dateFormatter.string(from: date))
        })
        return encoder
    }()
    
    private(set) var form: Form!
    
    open var jsonResource: String {
        "MedicalIntake23"
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: jsonResource, withExtension: "json"))
        let data = try Data(contentsOf: url)
        form = try Self.decoder.decode(Typeform.Form.self, from: data)
    }
}
