import Foundation
import Testing
@testable import Typeform
import TypeformPreview

struct SchemeTests {

    @Test func encodeForm() throws {
        let form = Form()
        let data = try TypeformTests.prettyEncoder.encode(form)
        let json = String(String(decoding: data, as: UTF8.self))

        #expect(json == """
        {
          "_links" : {
            "display" : "https:\\/\\/www.typeform.com"
          },
          "fields" : [

          ],
          "id" : "",
          "logic" : [

          ],
          "settings" : {
            "are_uploads_public" : false,
            "hide_navigation" : false,
            "is_public" : false,
            "is_trial" : false,
            "language" : "",
            "meta" : {
              "allow_indexing" : false
            },
            "pro_subdomain_enabled" : false,
            "progress_bar" : "",
            "show_cookie_consent" : false,
            "show_number_of_submissions" : false,
            "show_progress_bar" : false,
            "show_question_number" : false,
            "show_time_to_complete" : false,
            "show_typeform_branding" : false
          },
          "thankyou_screens" : [

          ],
          "theme" : {
            "href" : "https:\\/\\/www.typeform.com"
          },
          "title" : "",
          "type" : "quiz",
          "workspace" : {
            "href" : "https:\\/\\/www.typeform.com"
          }
        }
        """)
    }

    @Test func encodeDefaultThankYou() throws {
        let screen = EndingScreen.defaultThankYou
        let data = try TypeformTests.prettyEncoder.encode(screen)
        let json = String(decoding: data, as: UTF8.self)
        #expect(json == """
        {
          "id" : "DefaultTyScreen",
          "properties" : {
            "share_icons" : false,
            "show_button" : false
          },
          "ref" : "default_tys",
          "title" : "All done!, Thanks for you time.",
          "type" : "thankyou_screen"
        }
        """)
    }

    func testDecodeIntake24() throws {
        _ = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MedicalIntake24")
    }

    func testDecodeIntake26() throws {
        let form = try Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MedicalIntake23")
        let field = try #require(form.field(withId: "0mMHJCj4JoPr"))
        guard case .statement(let statement) = field.properties else {
            Issue.record()
            return
        }

        #expect(statement.description != nil)
        #expect(statement.button_text == "Acknowledge & Continue")
    }
}
