@testable import Typeform
@testable import TypeformPreview
import XCTest

final class PreLoadedResponsesTests: TypeformTests {

    override var jsonResource: String { "MedicalIntake26" }

    func testNotSkippingWelcomeEmptyResponses() throws {
        let responses: Responses = [:]
        let position = try form.firstPosition(skipWelcomeScreen: false, given: responses)
        guard case let .screen(screen) = position else {
            XCTFail("Unexpected Position")
            return
        }

        guard let welcomeScreen = screen as? WelcomeScreen else {
            XCTFail("Unexpected Screen")
            return
        }

        XCTAssertEqual(welcomeScreen.id, "NGCT4k03bG7W")
    }

    func testNotSkippingWelcomeFirstFieldResponses() throws {
        let responses: Responses = [
            .uuid(UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!): .choice(
                Choice(
                    id: "eSMBTpzeqJYQ",
                    ref: .string("65fd22c3-32ec-4c92-b194-5aef3a10fe60"),
                    label: "Alabama"
                )
            ),
        ]

        let position = try form.firstPosition(skipWelcomeScreen: false, given: responses)
        guard case let .screen(screen) = position else {
            XCTFail("Unexpected Position")
            return
        }

        guard let welcomeScreen = screen as? WelcomeScreen else {
            XCTFail("Unexpected Screen")
            return
        }

        XCTAssertEqual(welcomeScreen.id, "NGCT4k03bG7W")
    }

    func testSkippingWelcomeEmptyResponses() throws {
        let responses: Responses = [:]

        let position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(field, group) = position else {
            XCTFail("Unexpected Position")
            return
        }

        XCTAssertEqual(field.id, "89Ofk9JaI4M1")
        XCTAssertNil(group)
    }

    func testSkippingWelcomeFirstFieldResponses() throws {
        let responses: Responses = [
            .uuid(UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!): .choice(
                Choice(
                    id: "Rh7fHLNn7tRV",
                    ref: .uuid(UUID(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!),
                    label: "Minnesota"
                )
            ),
        ]

        let position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(field, group) = position else {
            XCTFail("Unexpected Position")
            return
        }

        XCTAssertEqual(field.id, "0mMHJCj4JoPr")
        XCTAssertNil(group)
    }

    /// There is a 'Statement' field after the first response, and before the second response. What comes after that field?
    func testSkippingWelcomePostStatementResponses() throws {
        let responses: Responses = [
            .uuid(UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!): .choice(
                Choice(
                    id: "Rh7fHLNn7tRV",
                    ref: .uuid(UUID(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!),
                    label: "Minnesota"
                )
            ),
            .uuid(UUID(uuidString: "4915db69-55ca-4a00-b57e-893d7ea3e761")!): .choice(
                Choice(
                    id: "QQP6V2LnuOBK",
                    ref: .uuid(UUID(uuidString: "a66c1065-4e4f-46fc-8a26-794cc46a59f9")!),
                    label: "Adult, 18-64 years of age"
                )
            ),
        ]

        var position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(field, group) = position else {
            XCTFail("Unexpected Position")
            return
        }

        XCTAssertEqual(field.id, "0mMHJCj4JoPr")
        XCTAssertNil(group)

        position = try form.next(from: position, given: responses)

        guard case let .field(nextField, nextGroup) = position else {
            XCTFail("Unexpected Position")
            return
        }

        XCTAssertEqual(nextField.id, "0QSfTuGGV8W5")
        XCTAssertNil(nextGroup)
    }
}
