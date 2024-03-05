import XCTest
@testable import Typeform
@testable import TypeformPreview

final class PTIntakeTests: TypeformTests {
    
    override var jsonResource: String { "PTIntake42" }
    
    func testLastFieldToThankYouScreen() throws {
        let responses: Responses = [
            .string("age-category"): .int(30),
            .string("biological-sex"): .choice(
                Choice(id: "AlXZD8PosUqK", ref: .string("biological-sex-answer-male"), label: "Male")
            ),
            .string("health-history-form-completed"): .bool(true),
            .string("health-history-changed"): .bool(false),
            .string("reason-for-visit-physical-therapy-symptoms-location"): .choices([
                Choice(id: "rTLcSvPGbEE6", ref: .string("reason-for-visit-physical-therapy-symptoms-location-answer-low-back"), label: "Low back")
            ]),
            .string("reason-for-visit-physical-therapy-symptoms"): .choices([
                Choice(id: "lpOqwXIWFqVQ", ref: .string("reason-for-visit-physical-therapy-symptoms-answer-stiffness"), label: "Stiffness or aching")
            ]),
            .string("reason-for-visit-physical-therapy-symptoms-duration"): .choice(
                Choice(id: "w0WxgI0n6ias", ref: .string("reason-for-visit-physical-therapy-symptoms-duration-answer-one-week"), label: "Less than 2 weeks")
            ),
            Reference(uuidString: "49bbbbb5-b2db-4fe6-9257-2cea7a21159f")!: .int(1),
            Reference(uuidString: "8bad022d-fb6d-497c-a4c2-ade0ad99d696")!: .int(1),
            .string("reason-for-visit-physical-therapy-symptoms-effect"): .string("pain"),
            .string("reason-for-visit-physical-therapy-symptoms-effect-severity"): .int(1),
            Reference(uuidString: "87249736-4231-4da0-b626-50c48dc91c27")!: .choice(
                Choice(id: "CcH9VF3OO56t", ref: Reference(uuidString: "4bc77e92-c70c-442b-aa87-09aac3df4eea")!, label: "Nearly every day")
            ),
            Reference(uuidString: "c0dde0d4-0f31-45fd-ba13-d460ad13cb32")!: .choice(
                Choice(id: "GQSWmGIq0f3k", ref: Reference(uuidString: "a8ccca7e-37d2-409d-b52f-53f7e8aa8712")!, label: "Not at all")
            ),
            Reference(uuidString: "ab1805b7-1cba-474c-aee3-1a2a17683b8c")!:  .int(1),
            Reference(uuidString: "187a3247-605d-467d-9477-bc4e13c476b5")!:  .int(1),
            Reference(uuidString: "ccc8ef20-2cbc-48e7-aaf5-512b5ba6cf88")!:  .int(1),
            .string("reason-for-visit-physical-therapy-detail"): .string("info")
        ]
        
        var position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(statementField, _) = position else {
            XCTFail("Unexpected Position")
            return
        }
        
        XCTAssertEqual(statementField.id, "iJolnxu6Sftn")
        position = try form.next(from: position, given: responses)
        
        guard case let .field(continueField, _) = position else {
            XCTFail("Unexpected Position")
            return
        }
        
        XCTAssertEqual(continueField.id, "cLKRIr0wbDP9")
        
        position = try form.next(from: position, given: responses)
        guard case let .field(reasonField, _) = position else {
            XCTFail("Unexpected Position")
            return
        }
        
        XCTAssertEqual(reasonField.id, "XrGAAaW3t7BW")
        
        position = try form.next(from: position, given: responses)
        guard case let .screen(thankYouScreen) = position else {
            XCTFail("Unexpected Position")
            return
        }
        
        XCTAssertEqual(thankYouScreen.id, "DefaultTyScreen")
    }
}
