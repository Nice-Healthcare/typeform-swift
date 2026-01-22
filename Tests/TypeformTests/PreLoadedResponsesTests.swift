import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct PreLoadedResponsesTests {

    private let form: Typeform.Form

    init() throws {
        form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MedicalIntake26")
    }

    @Test func notSkippingWelcomeEmptyResponses() throws {
        let responses: Responses = [:]
        let position = try form.firstPosition(skipWelcomeScreen: false, given: responses)
        guard case let .screen(screen) = position else {
            Issue.record("Unexpected Position")
            return
        }

        guard let welcomeScreen = screen as? WelcomeScreen else {
            Issue.record("Unexpected Screen")
            return
        }

        #expect(welcomeScreen.id == "NGCT4k03bG7W")
    }

    @Test func notSkippingWelcomeFirstFieldResponses() throws {
        let responses: Responses = [
            .uuid(UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!): .choice(
                Choice(
                    id: "eSMBTpzeqJYQ",
                    ref: .string("65fd22c3-32ec-4c92-b194-5aef3a10fe60"),
                    label: "Alabama",
                ),
            ),
        ]

        let position = try form.firstPosition(skipWelcomeScreen: false, given: responses)
        guard case let .screen(screen) = position else {
            Issue.record("Unexpected Position")
            return
        }

        guard let welcomeScreen = screen as? WelcomeScreen else {
            Issue.record("Unexpected Screen")
            return
        }

        #expect(welcomeScreen.id == "NGCT4k03bG7W")
    }

    @Test func skippingWelcomeEmptyResponses() throws {
        let responses: Responses = [:]

        let position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(field, group) = position else {
            Issue.record("Unexpected Position")
            return
        }

        #expect(field.id == "89Ofk9JaI4M1")
        #expect(group == nil)
    }

    @Test func skippingWelcomeFirstFieldResponses() throws {
        let responses: Responses = [
            .uuid(UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!): .choice(
                Choice(
                    id: "Rh7fHLNn7tRV",
                    ref: .uuid(UUID(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!),
                    label: "Minnesota",
                ),
            ),
        ]

        let position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(field, group) = position else {
            Issue.record("Unexpected Position")
            return
        }

        #expect(field.id == "0mMHJCj4JoPr")
        #expect(group == nil)
    }

    /// There is a 'Statement' field after the first response, and before the second response. What comes after that field?
    @Test func skippingWelcomePostStatementResponses() throws {
        let responses: Responses = [
            .uuid(UUID(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!): .choice(
                Choice(
                    id: "Rh7fHLNn7tRV",
                    ref: .uuid(UUID(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!),
                    label: "Minnesota",
                ),
            ),
            .uuid(UUID(uuidString: "4915db69-55ca-4a00-b57e-893d7ea3e761")!): .choice(
                Choice(
                    id: "QQP6V2LnuOBK",
                    ref: .uuid(UUID(uuidString: "a66c1065-4e4f-46fc-8a26-794cc46a59f9")!),
                    label: "Adult, 18-64 years of age",
                ),
            ),
        ]

        var position = try form.firstPosition(skipWelcomeScreen: true, given: responses)
        guard case let .field(field, group) = position else {
            Issue.record("Unexpected Position")
            return
        }

        #expect(field.id == "0mMHJCj4JoPr")
        #expect(group == nil)

        position = try form.next(from: position, given: responses)

        guard case let .field(nextField, nextGroup) = position else {
            Issue.record("Unexpected Position")
            return
        }

        #expect(nextField.id == "0QSfTuGGV8W5")
        #expect(nextGroup == nil)
    }
}
