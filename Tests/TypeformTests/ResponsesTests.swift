import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct ResponsesTests {

    private let form: Typeform.Form
    private let visitReason = Reference(uuidString: "aea7a268-64d4-4f16-920a-b9afe317e3b6")!
    private let visitChoice = Choice(
        id: "Sx6ZqqmkAHOI",
        ref: Reference(uuidString: "4f6732f3-d3b6-4c83-9c3e-a4945a004507")!,
        label: "An update or follow-up on how you are feeling regarding an illness or injury that was discussed with a Specialty medical provider"
    )

    init() throws {
        form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MedicalIntake23")
    }

    /// Verify the `Reference.valueEncodingCase` options.
    ///
    /// - note: The double quote is correct; JSON fragment.
    @Test func referenceEncoding() throws {
        Reference.valueEncodingCase = .automatic
        var data = try TypeformTests.encoder.encode(visitReason)
        var value = String(decoding: data, as: UTF8.self)
        #expect(value == #""AEA7A268-64D4-4F16-920A-B9AFE317E3B6""#)

        Reference.valueEncodingCase = .uppercase
        data = try TypeformTests.encoder.encode(visitReason)
        value = String(decoding: data, as: UTF8.self)
        #expect(value == #""AEA7A268-64D4-4F16-920A-B9AFE317E3B6""#)

        Reference.valueEncodingCase = .lowercase
        data = try TypeformTests.encoder.encode(visitReason)
        value = String(decoding: data, as: UTF8.self)
        #expect(value == #""aea7a268-64d4-4f16-920a-b9afe317e3b6""#)
    }

    @Test func validVisitReasonResponses() throws {
        let responses: Responses = [
            visitReason: .choice(visitChoice),
        ]
        #expect(responses.validResponseValues(given: form.fields))
    }

    @Test func invalidVisitReasonResponses() throws {
        let responses: Responses = [
            visitReason: .choices([visitChoice]),
        ]
        #expect(!responses.validResponseValues(given: form.fields))
    }

    @Test func validResponseValueTypes() throws {
        let responses: Responses = [
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
        #expect(responses.validResponseValues(given: form.fields))
    }

    @Test func invalidResponseValueTypes() throws {
        let responses: Responses = [
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
        #expect(invalidKeys.count == 9)
        #expect(Set(invalidKeys) == [
            .date, .dropdown, .longText, .multipleChoice_Many,
            .multipleChoice_One, .number, .rating, .shortText, .yesNo,
        ])
    }

    @Test func defaultResponseValueEncoding() throws {
        let responses: Responses = [
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

        let data = try TypeformTests.prettyEncoder.encode(responses.encodableDictionary)
        let json = String(decoding: data, as: UTF8.self)
        #expect(json == """
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

    @Test func defaultResponseValueDecoding() throws {
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
        let date = try #require(dateComponents.date)

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
        let data = try #require(json.data(using: .utf8))
        let responses = try TypeformTests.decoder.decodeResponses(from: data)
        #expect(responses == [
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
