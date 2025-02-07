@testable import Typeform
@testable import TypeformPreview
import XCTest

class ImageAttachmentTests: TypeformTests {

    override var jsonResource: String { "ImageAttachment" }

    func testFormStart() throws {
        let firstPosition = try form.firstPosition(
            skipWelcomeScreen: false,
            given: [:]
        )

        guard case .field(let field, _) = firstPosition else {
            XCTFail()
            return
        }

        XCTAssertEqual(field.id, "21xteNrP8VJs")
    }
}
