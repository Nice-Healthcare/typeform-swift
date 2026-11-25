import Foundation
import Testing
@testable import Typeform

struct StructuralQuestionTests {
    @Test func `Decode Structural Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "StructuralQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "pUoGuGJD")
    }
}
