import Foundation
import Testing
@testable import Typeform

struct RatingQuestionTests {
    @Test func `Decode Rating Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "RatingQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "gbyk9YV3")
    }
}
