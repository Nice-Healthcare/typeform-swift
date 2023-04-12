import XCTest
@testable import Typeform

final class ResponsesTests: TypeformTests {
    
    var responses: Responses = [:]
    
    private let visitReason = Reference(uuidString: "aea7a268-64d4-4f16-920a-b9afe317e3b6")!
    private let visitChoice = Choice(
        id: "Sx6ZqqmkAHOI",
        ref: Reference(uuidString: "4f6732f3-d3b6-4c83-9c3e-a4945a004507")!,
        label: "An update or follow-up on how you are feeling regarding an illness or injury that was discussed with a Specialty medical provider"
    )
    
    /// Verify the `Reference.valueEncodingCase` options.
    ///
    /// - note: The double quote is correct; JSON fragment.
    func testReferenceEncoding() throws {
        Reference.valueEncodingCase = .automatic
        var data = try TypeformTests.encoder.encode(visitReason)
        var value = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(value, #""AEA7A268-64D4-4F16-920A-B9AFE317E3B6""#)
        
        Reference.valueEncodingCase = .uppercase
        data = try TypeformTests.encoder.encode(visitReason)
        value = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(value, #""AEA7A268-64D4-4F16-920A-B9AFE317E3B6""#)
        
        Reference.valueEncodingCase = .lowercase
        data = try TypeformTests.encoder.encode(visitReason)
        value = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(value, #""aea7a268-64d4-4f16-920a-b9afe317e3b6""#)
    }
    
    func testValidVisitReasonResponses() throws {
        responses[visitReason] = .choice(visitChoice)
        XCTAssertTrue(responses.validResponseValues(given: form.fields))
    }
    
    func testInvalidVisitReasonResponses() throws {
        responses[visitReason] = .choices([visitChoice])
        XCTAssertFalse(responses.validResponseValues(given: form.fields))
    }
    
    func testValidResponseValueTypes() throws {
        responses = [
            .date: .date(Date()),
            .dropdown: .choice(Choice()),
            .longText: .string(""),
            .multipleChoice_Many: .choices([]),
            .multipleChoice_One: .choice(Choice()),
            .number: .int(0),
            .rating: .int(0),
            .shortText: .string(""),
            .yesNo: .bool(false)
        ]
        XCTAssertTrue(responses.validResponseValues(given: form.fields))
    }
    
    func testInvalidResponseValueTypes() throws {
        responses = [
            .date: .choice(Choice()),
            .dropdown: .date(Date()),
            .longText: .choice(Choice()),
            .multipleChoice_Many: .string(""),
            .multipleChoice_One: .choices([]),
            .number: .string(""),
            .rating: .bool(false),
            .shortText: .int(0),
            .yesNo: .int(0)
        ]
        let invalidKeys = responses.invalidResponseValues(given: form.fields)
        XCTAssertEqual(invalidKeys.count, 9)
        XCTAssertEqual(Set(invalidKeys), [
            .date, .dropdown, .longText, .multipleChoice_Many,
            .multipleChoice_One, .number, .rating, .shortText, .yesNo
        ])
    }
}
