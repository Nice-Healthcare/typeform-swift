import XCTest
@testable import Typeform
@testable import TypeformPreview

final class PrimaryCareFormTests: TypeformTests {
    
    override var jsonResource: String { "PrimaryCareV3" }
    
    func testDecoding() throws {
        XCTAssertEqual(form.id, "hdgks8bb")
    }
}
