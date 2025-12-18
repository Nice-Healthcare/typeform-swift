import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct FormScreenTests {

    private let form: Typeform.Form

    init() throws {
        form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MedicalIntake23")
    }

    @Test func testFirstScreen() throws {
        let screen = try #require(form.firstScreen)
        let welcomeScreen = try #require(screen as? WelcomeScreen)

        #expect(welcomeScreen.id == "DmQFaO34DUcM")
        #expect(welcomeScreen.ref == Reference(uuidString: "122872b0-4de9-42c2-9204-fdec922538af"))
        #expect(welcomeScreen.title.hasPrefix("Hello and thanks for reaching out"))
        #expect(welcomeScreen.properties.button_text == "Start")
    }

    @Test func testDefaultOrFirstEndingScreen() throws {
        let endingScreen = try #require(form.defaultOrFirstEndingScreen)

        #expect(endingScreen.id == "DefaultTyScreen")
        #expect(endingScreen.ref == .default)
        #expect(endingScreen.title == "All done! Thanks for your time.")
    }
}
