import Foundation
import Testing
@testable import Typeform

struct ChoiceQuestionTests {
    @Test func `Decode Choice Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "ChoiceQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "rjfMk8d6")
        #expect(form.fields.count == 7)

        let field1 = try #require(form.field(withId: "G9ClmExohfBK"))
        #expect(field1.type == .multipleChoice)
        #expect(field1.validations?.required == false)
        let multipleChoice1 = try #require(field1.properties.asMultipleChoice())
        #expect(multipleChoice1.choices.count == 2)
        #expect(!multipleChoice1.randomize)
        #expect(!multipleChoice1.allowMultipleSelection)
        #expect(!multipleChoice1.allowOtherChoice)
        #expect(!multipleChoice1.allowNoneOfTheAbove)

        let field2 = try #require(form.field(withId: "N6ZbDOKXnJvG"))
        #expect(field2.type == .multipleChoice)
        #expect(field2.title == "Fancy Multiple Choice")
        #expect(field2.validations?.required == false)
        #expect(field2.validations?.minSelection == 1)
        #expect(field2.validations?.maxSelection == 3)
        let multipleChoice2 = try #require(field2.properties.asMultipleChoice())
        #expect(multipleChoice2.choices.count == 3)
        #expect(multipleChoice2.randomize)
        #expect(multipleChoice2.allowMultipleSelection)
        #expect(multipleChoice2.allowOtherChoice)
        #expect(multipleChoice2.allowNoneOfTheAbove)

        let field3 = try #require(form.field(withId: "OHqUNUZag8is"))
        #expect(field3.type == .dropdown)
        #expect(field3.validations?.required == false)
        let dropDown = try #require(field3.properties.asDropdown())
        #expect(dropDown.choices.count == 4)
        #expect(!dropDown.randomize)
        #expect(!dropDown.alphabetical)

        let field4 = try #require(form.field(withId: "8er9WLcAq5gh"))
        #expect(field4.type == .pictureChoice)
        #expect(field4.validations?.required == false)
        let pictureChoice = try #require(field4.properties.asPictureChoice())
        #expect(!pictureChoice.randomize)
        #expect(!pictureChoice.allowMultipleSelection)
        #expect(!pictureChoice.allowOtherChoice)
        #expect(!pictureChoice.allowNoneOfTheAbove)
        #expect(!pictureChoice.supersized)
        #expect(pictureChoice.showLabels)
        for choice in pictureChoice.choices {
            switch choice.ref.rawValue {
            case "b9018029-b0ad-4a58-99df-5aa179964ed2":
                #expect(choice.attachment?.properties?.description == "Heart")
            case "d37bd29f-9949-4e31-80ff-6900e44431f3":
                #expect(choice.attachment?.properties?.description == "Dog")
            case "72b6ea22-e117-4078-afc6-1a663a65514c":
                #expect(choice.attachment?.properties?.description == "Command")
            default:
                Issue.record("Unknown Choice")
            }
        }

        let field5 = try #require(form.field(withId: "p747qlN7Wu4V"))
        #expect(field5.type == .legal)
        #expect(field5.validations?.required == false)

        let field6 = try #require(form.field(withId: "A6ZTXJEWjKu0"))
        #expect(field6.type == .checkbox)
        #expect(field6.validations?.required == false)
        let checkbox = try #require(field6.properties.asCheckbox())
        #expect(checkbox.choices.count == 1)
    }
}
