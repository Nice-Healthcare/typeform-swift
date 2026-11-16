import Foundation
import Testing
@testable import Typeform

struct ContactQuestionTests {
    @Test func `Decode Contact Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "ContactQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
    }
}
