import XCTest
@testable import Typeform
@testable import TypeformPreview

final class ReferenceTests: TypeformTests {
    
    /// Test that `Reference.string` cases are successfully decoded.
    ///
    /// Earlier iterations of this work expected a `UUID` for all references.
    func testGenericReferences() throws {
        let url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "GenericSlugs", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try Self.decoder.decode(Typeform.Form.self, from: data)
        
        let launchField = try XCTUnwrap(form.fields.first)
        XCTAssertEqual(launchField.id, "ShzJTN0Q8FUf")
        
        let field = try XCTUnwrap(form.field(withId: "ylVxZah5X9Sq"))
        guard case .string(let value) = field.ref else {
            return XCTFail("Unexpected Field Ref Type")
        }
        
        XCTAssertEqual(value, "preferred-pharmacy")
    }
}
