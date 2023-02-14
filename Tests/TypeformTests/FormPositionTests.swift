import XCTest
@testable import Typeform
@testable import TypeformPreview

final class FormPositionTests: TypeformTests {
    
    var responses: Responses = [:]
    
    /// Verify the transition from a `WelcomeScreen` to the first `Field` in a `Form`.
    func testNextFromWelcome() throws {
        let welcome = WelcomeScreen.preview
        let next = try form.next(from: .screen(welcome), given: responses)
        
        guard case .field(let field, let group) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertNil(group)
        XCTAssertEqual(field.id, "5kmu6eCtBcYH")
        XCTAssertEqual(field.ref, UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2"))
        XCTAssertEqual(field.title, "What state do you live in?")
        XCTAssertEqual(field.type, .dropdown)
    }
    
    /// Verify that responses change the result of calling `Form.next(from:given:)`
    ///
    /// In this test, the first _state_ selection changes which `Field` is presented _next_.
    func testLogicChangesNext() throws {
        let stateField = try XCTUnwrap(form.fields.first(where: { $0.id == "5kmu6eCtBcYH" }))
        guard case .dropdown(let stateDropdown) = stateField.properties else {
            return XCTFail("Unexpected `Field.Properties`")
        }
        let stateMinnesota = try XCTUnwrap(stateDropdown.choices.first(where: { $0.id == "ki7l02wXkJJB" }))
        let stateLouisiana = try XCTUnwrap(stateDropdown.choices.first(where: { $0.id == "44eDpNiPK9Lp" }))
        
        responses = [
            stateField.ref: .choice(stateLouisiana)
        ]
        
        var next = try form.next(from: .field(stateField, nil), given: responses)
        
        guard case .field(let field1, let group1) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertNil(group1)
        XCTAssertEqual(field1.id, "eG0YCnJUpu1N")
        
        responses = [
            stateField.ref: .choice(stateMinnesota)
        ]
        
        next = try form.next(from: .field(stateField, nil), given: responses)
        
        guard case .field(let field2, let group2) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertNil(group2)
        XCTAssertEqual(field2.id, "qCewzRklnpSW")
    }
    
    /// Verify a `Group` of questions can be entered from a `Field` without specific `Logic`.
    func testBeginGroup() throws {
        responses = [
            Reference(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!: .choice(Choice(
                id: "ki7l02wXkJJB",
                ref: Reference(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!,
                label: "Minnesota"
            )),
            Reference(uuidString: "4915db69-55ca-4a00-b57e-893d7ea3e761")!: .choice(Choice(
                id: "zkoKtHgiYyKt",
                ref: Reference(uuidString: "a66c1065-4e4f-46fc-8a26-794cc46a59f9")!,
                label: "Adult, 18-64 years of age"
            )),
            Reference(uuidString: "c09778dd-d584-40cc-8517-a627592ca5f1")!: .choice(Choice(
                id: "FRF7t7yJYhEd",
                ref: Reference(uuidString: "a5e3cd94-58f6-4701-8632-dc3cc030dde5")!,
                label: "Male"
            )),
        ]
        
        let genderField = try XCTUnwrap(form.fields.first(where: { $0.id == "gFDX3w26M8yg" }))
        var next = try form.next(from: .field(genderField, nil), given: responses)
        
        guard case .field(let field1, let group1) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertEqual(field1.id, "us8oIodSBXkx")
        XCTAssertEqual(field1.type, .group)
        XCTAssertNil(group1)
        
        next = try form.next(from: .field(field1, group1), given: responses)
        
        guard case .field(let field2, let group2) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertEqual(field2.id, "33TQPEdKii8T")
        XCTAssertEqual(group2?.fields.count, 4)
    }
    
    /// Verify leaving a `Group` without specific `Logic` returns to the next `Field`.
    func testEndGroup() throws {
        responses = [
            Reference(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!: .choice(Choice(
                id: "ki7l02wXkJJB",
                ref: Reference(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!,
                label: "Minnesota"
            )),
            Reference(uuidString: "4915db69-55ca-4a00-b57e-893d7ea3e761")!: .choice(Choice(
                id: "zkoKtHgiYyKt",
                ref: Reference(uuidString: "a66c1065-4e4f-46fc-8a26-794cc46a59f9")!,
                label: "Adult, 18-64 years of age"
            )),
            Reference(uuidString: "c09778dd-d584-40cc-8517-a627592ca5f1")!: .choice(Choice(
                id: "FRF7t7yJYhEd",
                ref: Reference(uuidString: "a5e3cd94-58f6-4701-8632-dc3cc030dde5")!,
                label: "Male"
            )),
            Reference(uuidString: "7f57a989-19d3-40b8-af66-d022d3ebb73f")!: .bool(true),
            Reference(uuidString: "5d99768b-65af-4f68-9939-87dfbd29f49a")!: .bool(false),
            Reference(uuidString: "aea7a268-64d4-4f16-920a-b9afe317e3b6")!: .choice(Choice(
                id: "BQbGWsw0MzIZ",
                ref: Reference(uuidString: "c9291e36-0cf3-454c-b9f6-c96538ef6b5f")!,
                label: "A follow-up visit for continued wellness coaching"
            )),
        ]
        
        let location = try XCTUnwrap(form.fields.first(where: { $0.id == "XisVeizxVZm0" }))
        guard case .group(let group) = location.properties else {
            return XCTFail("Unexpected `Field`")
        }
        
        let parkingInstructions = try XCTUnwrap(group.fields.first(where: { $0.id == "giRxNIAxLYEh" }))
        
        let next = try form.next(from: .field(parkingInstructions, group), given: responses)
        
        guard case .field(let field, _) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertEqual(field.id, "G8f85EPqK4wy")
    }
    
    func testNoLogicNextField() throws {
        responses = [
            Reference(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!: .choice(Choice(
                id: "ki7l02wXkJJB",
                ref: Reference(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!,
                label: "Minnesota"
            )),
            Reference(uuidString: "4915db69-55ca-4a00-b57e-893d7ea3e761")!: .choice(Choice(
                id: "zkoKtHgiYyKt",
                ref: Reference(uuidString: "a66c1065-4e4f-46fc-8a26-794cc46a59f9")!,
                label: "Adult, 18-64 years of age"
            )),
            Reference(uuidString: "c09778dd-d584-40cc-8517-a627592ca5f1")!: .choice(Choice(
                id: "FRF7t7yJYhEd",
                ref: Reference(uuidString: "a5e3cd94-58f6-4701-8632-dc3cc030dde5")!,
                label: "Male"
            )),
            Reference(uuidString: "7f57a989-19d3-40b8-af66-d022d3ebb73f")!: .bool(true),
            Reference(uuidString: "5d99768b-65af-4f68-9939-87dfbd29f49a")!: .bool(false),
            Reference(uuidString: "aea7a268-64d4-4f16-920a-b9afe317e3b6")!: .choice(Choice(
                id: "BQbGWsw0MzIZ",
                ref: Reference(uuidString: "c9291e36-0cf3-454c-b9f6-c96538ef6b5f")!,
                label: "A follow-up visit for continued wellness coaching"
            )),
        ]
        
        let whatsNext = try XCTUnwrap(form.fields.first(where: { $0.id == "G8f85EPqK4wy" }))
        
        let next = try form.next(from: .field(whatsNext, nil), given: responses)
        
        guard case .field(let field, _) = next else {
            return XCTFail("Unexpected `Position`.")
        }
        
        XCTAssertEqual(field.id, "VIFWzjRMJ9sE")
    }
}
