import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct DemoFormTests {

    @Test func formStart() throws {
        let form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "DemoForm")
        var position = try form.firstPosition(
            skipWelcomeScreen: false,
            given: [:]
        )

        guard case .screen(let welcomeScreen) = position else {
            Issue.record()
            return
        }

        #expect(welcomeScreen.id == "iVVVXbYhFAqt")

        position = try form.next(from: position, given: [:])

        guard case .field(let field, _) = position else {
            Issue.record()
            return
        }

        #expect(field.id == "UKrtkRy8EAY2")
        #expect(field.type == .group)

        position = try form.next(from: position, given: [:])

        guard case .field(let nextField, let group) = position else {
            Issue.record()
            return
        }

        #expect(nextField.id == "M6IDI3o5xRXu")
        #expect(group != nil)
    }
}
