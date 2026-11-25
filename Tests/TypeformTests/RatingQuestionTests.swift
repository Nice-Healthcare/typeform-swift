import Foundation
import Testing
@testable import Typeform

struct RatingQuestionTests {
    @Test func `Decode Rating Questions`() throws {
        let url = try #require(Bundle.module.url(forResource: "RatingQuestions", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try JSONDecoder().decode(Form.self, from: data)
        #expect(form.id == "gbyk9YV3")
        #expect(form.fields.count == 5)

        let field1 = try #require(form.field(withId: "TAeseOB9Z6Om"))
        #expect(field1.type == .netPromoterScore)
        let nps = try #require(field1.properties.asNetPromoterScore())
        #expect(nps.steps == 11)

        let field2 = try #require(form.field(withId: "84g00Szs97Rx"))
        #expect(field2.type == .opinionScale)
        let opinionScale = try #require(field2.properties.asOpinionScale())
        #expect(opinionScale.steps == 5)
        #expect(opinionScale.startAtOne)
        let labels = try #require(opinionScale.labels)
        #expect(labels.leading == "Min")
        #expect(labels.center == "Mid")
        #expect(labels.trailing == "Max")

        let field3 = try #require(form.field(withId: "ZZHumjUpFg8e"))
        #expect(field3.type == .rating)
        let rating = try #require(field3.properties.asRating())
        #expect(rating.shape == "star")
        #expect(rating.steps == 3)

        let field4 = try #require(form.field(withId: "QihnYe13lg0F"))
        #expect(field4.type == .ranking)
        let ranking = try #require(field4.properties.asRanking())
        #expect(ranking.choices.count == 4)
        #expect(!ranking.randomize)
        #expect(ranking.allowMultipleSelection)

        let field5 = try #require(form.field(withId: "G7vDFLY4v8FI"))
        #expect(field5.type == .matrix)
        let matrix = try #require(field5.properties.asMatrix())
        #expect(matrix.fields.count == 2)
        #expect(matrix.columns == ["Column the First", "Column the Second"])
        #expect(matrix.rows == ["Row the First", "Row the Second"])
    }
}
