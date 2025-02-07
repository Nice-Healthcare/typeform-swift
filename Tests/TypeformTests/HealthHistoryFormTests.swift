@testable import Typeform
@testable import TypeformPreview
import XCTest

final class HealthHistoryFormTests: TypeformTests {

    override var jsonResource: String { "HealthHistoryV3" }

    func testDecoding() throws {
        XCTAssertEqual(form.id, "dmsX77W1")
    }

    func testMinorImmunization() throws {
        let responses: Responses = [
            .string("health-history-form-completed"): .bool(false),
            .string("patient-age"): .int(17),
            .string("sex-assigned-at-birth"): .choice(
                Choice(id: "gYxjsy4loTDH", ref: .string("sex-assigned-at-birth-answer-male"), label: "Male")
            ),
            .string("medications-usage"): .bool(false),
            .string("medication-allergies"): .bool(false),
            .string("surgeries"): .bool(false),
            .string("family-medical-history"): .string(""),
        ]

        let lastField = try XCTUnwrap(form.field(withRef: .string("family-medical-history")))
        let position = Position.field(lastField, nil)
        let next = try form.next(from: position, given: responses)
        guard case .field(let field, let group) = next else {
            throw TypeformError.couldNotDetermineNext(position)
        }

        XCTAssertEqual(field.ref, .string("minor-immunization-status"))
        XCTAssertNil(group)
    }
}
