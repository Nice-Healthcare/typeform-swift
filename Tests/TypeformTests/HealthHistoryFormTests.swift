import XCTest
@testable import Typeform
@testable import TypeformPreview

final class HealthHistoryFormTests: TypeformTests {
    
    override var jsonResource: String { "HealthHistoryV1" }
    
    func testDecoding() throws {
        XCTAssertEqual(form.id, "dmsX77W1-testing")
    }
}
