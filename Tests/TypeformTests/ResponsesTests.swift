@testable import Typeform
import XCTest

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
            .yesNo: .bool(false),
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
            .yesNo: .int(0),
        ]
        let invalidKeys = responses.invalidResponseValues(given: form.fields)
        XCTAssertEqual(invalidKeys.count, 9)
        XCTAssertEqual(Set(invalidKeys), [
            .date, .dropdown, .longText, .multipleChoice_Many,
            .multipleChoice_One, .number, .rating, .shortText, .yesNo,
        ])
    }

    func testDefaultResponseValueEncoding() throws {
        responses = [
            "one": .int(6),
            "two": .choice(
                Choice(
                    id: "s83hchg83",
                    ref: "sex-at-birth",
                    label: "Female"
                )
            ),
            "three": .string("Hello"),
        ]

        let data = try Self.prettyEncoder.encode(responses.encodableDictionary)
        let json = String(decoding: data, as: UTF8.self)
        XCTAssertEqual(json, """
        {
          "one" : {
            "int" : 6
          },
          "three" : {
            "string" : "Hello"
          },
          "two" : {
            "choice" : {
              "id" : "s83hchg83",
              "label" : "Female",
              "ref" : "sex-at-birth"
            }
          }
        }
        """)
    }

    func testDefaultResponseValueDecoding() throws {
        let dateComponents = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(identifier: "America/Chicago"),
            year: 2025,
            month: 6,
            day: 10,
            hour: 13,
            minute: 27,
            second: 00
        )
        let date = try XCTUnwrap(dateComponents.date)

        let json = """
        {
          "553D6E8C-5562-4A7B-89AF-9C8428428197": {
            "bool" : false
          },
          "alpha" : {
            "choice" : {
              "id" : "something",
              "label" : "Battlestar",
              "ref" : "70675439-3BA3-44F9-8807-949A5375ACEC"
            }
          },
          "beta" : {
            "date" : "2025-06-10T13:27:00-05:00"
          }
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        responses = try Self.decoder.decodeResponses(from: data)
        XCTAssertEqual(responses, [
            .uuid(UUID(uuidString: "553D6E8C-5562-4A7B-89AF-9C8428428197")!): .bool(false),
            "alpha": .choice(
                Choice(
                    id: "something",
                    ref: .uuid(UUID(uuidString: "70675439-3BA3-44F9-8807-949A5375ACEC")!),
                    label: "Battlestar"
                )
            ),
            "beta": .date(date),
        ])
    }
}
