import Foundation
import Testing
@testable import Typeform

struct TextAndNumberQuestionTests {
    @Test func `Decode Text & Number Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "TextAndNumberQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "m8cCG2gj")
    }
}
