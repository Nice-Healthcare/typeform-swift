import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct HealthHistoryFormTests {

    private let form: Typeform.Form

    init() throws {
        form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "HealthHistoryV3")
    }

    @Test func decoding() throws {
        #expect(form.id == "dmsX77W1")
    }

    @Test func minorImmunization() throws {
        let responses: Responses = [
            .string("health-history-form-completed"): .bool(false),
            .string("patient-age"): .int(17),
            .string("sex-assigned-at-birth"): .choice(
                Choice(id: "gYxjsy4loTDH", ref: .string("sex-assigned-at-birth-answer-male"), label: "Male"),
            ),
            .string("medications-usage"): .bool(false),
            .string("medication-allergies"): .bool(false),
            .string("surgeries"): .bool(false),
            .string("family-medical-history"): .string(""),
        ]

        let lastField = try #require(form.field(withRef: .string("family-medical-history")))
        let position = Position.field(lastField, nil)
        let next = try form.next(from: position, given: responses)
        guard case .field(let field, let group) = next else {
            throw TypeformError.couldNotDetermineNext(position)
        }

        #expect(field.ref == .string("minor-immunization-status"))
        #expect(group == nil)
    }
}
