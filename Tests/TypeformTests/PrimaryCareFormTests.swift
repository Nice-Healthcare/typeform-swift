@testable import Typeform
@testable import TypeformPreview
import XCTest

final class PrimaryCareFormTests: TypeformTests {

    override var jsonResource: String { "PrimaryCareV3" }

    func testDecoding() throws {
        XCTAssertEqual(form.id, "hdgks8bb")
    }
}
