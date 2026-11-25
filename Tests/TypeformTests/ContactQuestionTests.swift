import Foundation
import Testing
@testable import Typeform

struct ContactQuestionTests {
    @Test func `Decode Contact Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "ContactQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "uWFxvuWr")
        #expect(form.fields.count == 3)

        let field1 = try #require(form.fields.field(withRef: "86fed743-0e00-46a0-9651-e835afde7ce1"))
        #expect(field1.title == "Contact Info")
        #expect(field1.type == .inlineGroup)
        let inlineGroup = try #require(field1.properties.asInlineGroup())
        #expect(inlineGroup.fields.count == 5)
        #expect(inlineGroup.fields.compactMap { $0.properties.description }.isEmpty)
        let firstName = try #require(inlineGroup.fields.field(withId: "0nTBs1ZHkLmI"))
        #expect(firstName.type == .shortText)
        #expect(firstName.validations?.maxLength == 50)
        let phoneNumber = try #require(inlineGroup.fields.field(withId: "I4qpyh1KwqdV"))
        #expect(phoneNumber.type == .phoneNumber)
        #expect(phoneNumber.properties.asPhoneNumber()?.defaultCountryCode == "US")

        let field2 = try #require(form.fields.field(withRef: "2ddb9599-cd0d-48c7-b75d-8044477d495c"))
        #expect(field2.title == "Address")
        #expect(field2.type == .inlineGroup)
        let addressGroup = try #require(field2.properties.asInlineGroup())
        #expect(addressGroup.fields.count == 6)
        #expect(addressGroup.fields.compactMap { $0.properties.description }.isEmpty)
        let postCode = try #require(addressGroup.fields.field(withId: "u8TiAAXaXnhw"))
        let regex = try #require(try postCode.validations?.regex)
        #expect("55422".contains(regex))
        let wholeResult = try #require(try regex.wholeMatch(in: "55422"))
        #expect(wholeResult.count == 1)
        let firstResult = try #require(try regex.firstMatch(in: "55422"))
        #expect(firstResult.startIndex == 0)

        let field3 = try #require(form.fields.field(withRef: "69507396-0c6b-4ba8-84a8-e9398359d527"))
        #expect(field3.type == .website)
    }
}
