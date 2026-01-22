import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct ImageAttachmentTests {

    private let form: Typeform.Form

    init() throws {
        form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "ImageAttachment")
    }

    @Test func formStart() throws {
        let firstPosition = try form.firstPosition(
            skipWelcomeScreen: false,
            given: [:],
        )

        guard case .field(let field, _) = firstPosition else {
            Issue.record()
            return
        }

        #expect(field.id == "21xteNrP8VJs")
    }
}
