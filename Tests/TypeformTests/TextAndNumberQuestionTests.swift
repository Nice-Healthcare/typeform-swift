import Foundation
import Testing
@testable import Typeform

struct TextAndNumberQuestionTests {
    @Test func `Decode Text & Number Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "TextAndNumberQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "m8cCG2gj")
        #expect(form.fields.count == 4)

        let field1 = try #require(form.field(withRef: "3415ebdb-94f4-479b-9235-bd89e7a15383"))
        #expect(field1.type == .longText)
        #expect(field1.validations?.maxLength == 250)

        let field2 = try #require(form.field(withRef: "fbd5a9e2-5902-4479-a8d1-27000a98f4c3"))
        #expect(field2.type == .shortText)
        let shortText = try #require(field2.properties.asShortText())
        #expect(shortText.placeholder == "Looks the same…")

        let field3 = try #require(form.field(withRef: "50f7eba6-4a90-4164-bb24-4b0ec5fc699e"))
        #expect(field3.type == .number)
        #expect(field3.validations?.minValue == 0)
        #expect(field3.validations?.maxValue == 1)

        let field4 = try #require(form.field(withRef: "e1b6fd34-44ac-4d11-9639-37aaa5ba5a01"))
        #expect(field4.type == .date)
        #expect(field4.validations?.dateMax == "today")
        #expect(field4.validations?.dateMin == "2026-11-01")
        let date = try #require(field4.properties.asDate())
        #expect(date.separator == .forwardSlash)
        #expect(date.structure == .monthDayYear)
    }
}
