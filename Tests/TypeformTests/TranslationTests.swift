import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct TranslationTests {

    @Test func merge() throws {
        var form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "TranslationFormBase")

        var field = try #require(form.field(withRef: "minor-consent-recent-weight"))
        #expect(field.title == "What was a recent weight (in pounds)?")
        #expect(field.properties.description == "We use this information to safely prescribe medication. ")

        let translation = try Bundle.typeformPreview.decode(TranslatedForm.self, forResource: "TranslationForm(es)")
        form = form.merging(translatedForm: translation)
        field = try #require(form.field(withRef: "minor-consent-recent-weight"))
        #expect(field.title == "¿Cuál era su peso reciente (en libras)?")
        #expect(field.properties.description == "Usamos esta información para recetar medicamentos de manera segura.")
    }

    @Test func mergeAgain() throws {
        var form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "standard_typeform")

        var field = try #require(form.field(withRef: "health-history-female-pregnancy"))
        #expect(field.type == .multipleChoice)
        guard case .multipleChoice(let multipleChoice) = field.properties else {
            Issue.record()
            return
        }
        var choices = multipleChoice.choices.sorted(by: { $0.id < $1.id })
        #expect(choices.map(\.label) == [
            "There is no chance of pregnancy and I am not breastfeeding",
            "I am currently pregnant",
            "There is a chance of pregnancy",
            "I am currently breastfeeding",
        ])

        let translation = try Bundle.typeformPreview.decode(TranslatedForm.self, forResource: "translated_typeform")

        form = form.merging(translatedForm: translation)
        field = try #require(form.field(withRef: "health-history-female-pregnancy"))
        guard case .multipleChoice(let multipleChoice) = field.properties else {
            Issue.record()
            return
        }
        choices = multipleChoice.choices.sorted(by: { $0.id < $1.id })
        #expect(choices.map(\.label) == [
            "No hay posibilidad de embarazo y no estoy amamantando",
            "Actualmente estoy embarazada",
            "Existe la posibilidad de embarazo",
            "Actualmente estoy amamantando",
        ])
    }
}
