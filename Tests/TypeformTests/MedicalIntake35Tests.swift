@testable import Typeform
@testable import TypeformPreview
import XCTest

class MedicalIntake35Tests: TypeformTests {

    override var jsonResource: String { "MedicalIntake35" }

    var responses: Responses = [:]

    func testMultipleLogicPaths() throws {
        responses = [
            // State: Minnesota
            Reference(string: "appointment-state"): .choice(Choice(
                id: "0H6r4PQIWFI6",
                ref: Reference(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!,
                label: "Minnesota"
            )),
            // Medicaid: False
            Reference(string: "medicaid-enrolled"): .bool(false),
            // Age: Adult
            Reference(string: "age-category"): .choice(Choice(
                id: "GGVFPlEB66Zp",
                ref: Reference(uuidString: "a66c1065-4e4f-46fc-8a26-794cc46a59f9")!,
                label: "Adult, 18-64 years of age"
            )),
            // Biological sex: Male
            Reference(string: "biological-sex"): .choice(Choice(
                id: "AmCrMMmSX4z1",
                ref: Reference(uuidString: "a5e3cd94-58f6-4701-8632-dc3cc030dde5")!,
                label: "Male"
            )),
            // History Completed: True
            Reference(string: "health-history-form-completed"): .bool(true),
            // History Changed: False
            Reference(string: "health-history-changed"): .bool(false),
            // Reason for visit: Acute
            Reference(string: "reason-for-visit-category"): .choice(Choice(
                id: "sv3WlByh2Hlw",
                ref: Reference(uuidString: "3faf5f88-5171-4933-af0f-210716bf1a60")!,
                label: "Acute Care: Treat recent symptoms like a cough, sore throat, rash, etc."
            )),
            // Acute reason: Allergy
            Reference(string: "reason-for-visit-acute"): .choice(Choice(
                id: "tmJ0fxcOga9e",
                ref: Reference(uuidString: "3c7619c0-14fe-4844-8910-d6e67999beb2")!,
                label: "Allergy symptoms"
            )),
            // Followup Visit: False
            Reference(string: "reason-for-visit-acute-follow-up"): .bool(false),
            // Acute Other: Something
            Reference(string: "reason-for-visit-acute-symptoms-other"): .string("Other symptoms"),
        ]

        let currentGroupField = try XCTUnwrap(form.field(withRef: Reference(string: "reason-for-visit-acute-intro")))
        guard case .group(let currentGroup) = currentGroupField.properties else {
            XCTFail("Unexpected Properties")
            return
        }
        let currentField = try XCTUnwrap(form.field(withRef: Reference(string: "reason-for-visit-acute-symptoms-other")))
        let nextField = try XCTUnwrap(form.field(withRef: Reference(string: "reason-for-visit-acute-symptoms-duration")))

        let next = try form.next(from: .field(currentField, currentGroup), given: responses)
        guard case .field(let field, let group) = next else {
            XCTFail("Unexpected Position")
            return
        }

        XCTAssertEqual(group, currentGroup)
        XCTAssertEqual(field.id, nextField.id)
    }
}
