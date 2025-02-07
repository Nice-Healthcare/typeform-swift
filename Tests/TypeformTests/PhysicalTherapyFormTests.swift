@testable import Typeform
@testable import TypeformPreview
import XCTest

final class PhysicalTherapyFormTests: TypeformTests {

    override var jsonResource: String { "PhysicalTherapyV3" }

    func testDecoding() throws {
        XCTAssertEqual(form.id, "rGeAA7V5")
    }
}
