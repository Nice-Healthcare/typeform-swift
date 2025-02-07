@testable import Typeform
@testable import TypeformPreview
import XCTest

class DemoFormTests: TypeformTests {

    override var jsonResource: String { "DemoForm" }

    func testFormStart() throws {
        var position = try form.firstPosition(
            skipWelcomeScreen: false,
            given: [:]
        )

        guard case .screen(let welcomeScreen) = position else {
            XCTFail()
            return
        }

        XCTAssertEqual(welcomeScreen.id, "iVVVXbYhFAqt")

        position = try form.next(from: position, given: [:])

        guard case .field(let field, _) = position else {
            XCTFail()
            return
        }

        XCTAssertEqual(field.id, "UKrtkRy8EAY2")
        XCTAssertEqual(field.type, .group)

        position = try form.next(from: position, given: [:])

        guard case .field(let nextField, let group) = position else {
            XCTFail()
            return
        }

        XCTAssertEqual(nextField.id, "M6IDI3o5xRXu")
        XCTAssertNotNil(group)
    }
}
