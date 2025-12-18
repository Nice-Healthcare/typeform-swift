import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct ReferenceTests {

    /// Test that `Reference.string` cases are successfully decoded.
    ///
    /// Earlier iterations of this work expected a `UUID` for all references.
    func testGenericReferences() throws {
        let form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "GenericSlugs")

        let launchField = try #require(form.fields.first)
        #expect(launchField.id == "ShzJTN0Q8FUf")

        let field = try #require(form.field(withId: "ylVxZah5X9Sq"))
        guard case .string(let value) = field.ref else {
            Issue.record("Unexpected Field Ref Type")
            return
        }

        #expect(value == "preferred-pharmacy")
    }
}
