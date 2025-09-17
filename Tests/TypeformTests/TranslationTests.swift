@testable import Typeform
import XCTest

final class TranslationTests: TypeformTests {

    func testMerge() throws {
        var url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "TranslationFormBase", withExtension: "json"))
        var data = try Data(contentsOf: url)
        var form = try Self.decoder.decode(Typeform.Form.self, from: data)

        var field = try XCTUnwrap(form.field(withRef: "minor-consent-recent-weight"))
        XCTAssertEqual(field.title, "What was a recent weight (in pounds)?")
        XCTAssertEqual(field.properties.description, "We use this information to safely prescribe medication. ")

        url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "TranslationForm(es)", withExtension: "json"))
        data = try Data(contentsOf: url)
        let translation = try Self.decoder.decode(Typeform.TranslatedForm.self, from: data)

        form = form.merging(translatedForm: translation)
        field = try XCTUnwrap(form.field(withRef: "minor-consent-recent-weight"))
        XCTAssertEqual(field.title, "¿Cuál era su peso reciente (en libras)?")
        XCTAssertEqual(field.properties.description, "Usamos esta información para recetar medicamentos de manera segura.")
    }

    func testMergeAgain() throws {
        var url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "standard_typeform", withExtension: "json"))
        var data = try Data(contentsOf: url)
        var form = try Self.decoder.decode(Typeform.Form.self, from: data)

        var field = try XCTUnwrap(form.field(withRef: "health-history-female-pregnancy"))
        XCTAssertEqual(field.type, .multipleChoice)
        guard case .multipleChoice(let multipleChoice) = field.properties else {
            XCTFail()
            return
        }
        var choices = multipleChoice.choices.sorted(by: { $0.id < $1.id })
        XCTAssertEqual(choices.map(\.label), [
            "There is no chance of pregnancy and I am not breastfeeding",
            "I am currently pregnant",
            "There is a chance of pregnancy",
            "I am currently breastfeeding",
        ])

        url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "translated_typeform", withExtension: "json"))
        data = try Data(contentsOf: url)
        let translation = try Self.decoder.decode(Typeform.TranslatedForm.self, from: data)

        form = form.merging(translatedForm: translation)
        field = try XCTUnwrap(form.field(withRef: "health-history-female-pregnancy"))
        guard case .multipleChoice(let multipleChoice) = field.properties else {
            XCTFail()
            return
        }
        choices = multipleChoice.choices.sorted(by: { $0.id < $1.id })
        XCTAssertEqual(choices.map(\.label), [
            "No hay posibilidad de embarazo y no estoy amamantando",
            "Actualmente estoy embarazada",
            "Existe la posibilidad de embarazo",
            "Actualmente estoy amamantando",
        ])
    }
}
