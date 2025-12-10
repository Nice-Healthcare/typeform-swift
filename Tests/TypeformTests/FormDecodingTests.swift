import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct FormDecodingTests {

    @Test func primaryCareFormDecoding() throws {
        let form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "PrimaryCareV3")
        #expect(form.id == "hdgks8bb")
    }

    @Test func physicalTherapyFormDecoding() throws {
        let form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "PhysicalTherapyV3")
        #expect(form.id == "rGeAA7V5")
    }

    @Test func matrixExampleFormDecoding() throws {
        let form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MatrixExample")
        #expect(form.id == "WkORBn0g")
    }
}
