import XCTest
@testable import Typeform

final class FormScreenTests: TypeformTests {
    
    func testFirstScreen() throws {
        let screen = try XCTUnwrap(form.firstScreen)
        let welcomeScreen = try XCTUnwrap(screen as? WelcomeScreen)
        
        XCTAssertEqual(welcomeScreen.id, "DmQFaO34DUcM")
        XCTAssertEqual(welcomeScreen.ref, Reference(uuidString: "122872b0-4de9-42c2-9204-fdec922538af"))
        XCTAssertTrue(welcomeScreen.title.hasPrefix("Hello and thanks for reaching out"))
        XCTAssertEqual(welcomeScreen.properties.button_text, "Start")
    }
    
    func testDefaultOrFirstEndingScreen() throws {
        let endingScreen = try XCTUnwrap(form.defaultOrFirstEndingScreen)
        
        XCTAssertEqual(endingScreen.id, "DefaultTyScreen")
        XCTAssertEqual(endingScreen.ref, .default)
        XCTAssertEqual(endingScreen.title, "All done! Thanks for your time.")
    }
}
