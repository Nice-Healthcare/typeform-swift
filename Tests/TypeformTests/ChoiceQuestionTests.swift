import Foundation
import Testing
@testable import Typeform

struct ChoiceQuestionTests {
    @Test func `Decode Choice Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "ChoiceQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "rjfMk8d6")
    }
}
