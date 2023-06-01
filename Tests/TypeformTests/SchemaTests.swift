import XCTest
@testable import Typeform

final class SchemeTests: TypeformTests {
    
    func testEncodeForm() throws {
        let form = Form(
            createdAt: .distantPast,
            publishedAt: .distantPast,
            lastUpdatedAt: .distantPast
        )
        let data = try TypeformTests.prettyEncoder.encode(form)
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        #if os(Linux)
        let distantPast = "0001-12-30T00:00:00+00:00"
        #else
        let distantPast = "0001-01-01T00:00:00+00:00"
        #endif
        
        XCTAssertEqual(json, """
        {
          "_links" : {
            "display" : "https:\\/\\/www.typeform.com"
          },
          "created_at" : "\(distantPast)",
          "fields" : [

          ],
          "hidden" : [

          ],
          "id" : "",
          "last_updated_at" : "\(distantPast)",
          "logic" : [

          ],
          "published_at" : "\(distantPast)",
          "settings" : {
            "are_uploads_public" : false,
            "capabilities" : {
              "e2e_encryption" : {
                "enabled" : false,
                "modifiable" : false
              }
            },
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
          "welcome_screens" : [

          ],
          "workspace" : {
            "href" : "https:\\/\\/www.typeform.com"
          }
        }
        """)
    }
    
    func testEncodeDefaultThankYou() throws {
        let screen = EndingScreen.defaultThankYou
        let data = try TypeformTests.prettyEncoder.encode(screen)
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(json, """
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
        let url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "MedicalIntake24", withExtension: "json"))
        let data = try Data(contentsOf: url)
        _ = try Self.decoder.decode(Typeform.Form.self, from: data)
    }
    
    func testDecodeIntake26() throws {
        let url = try XCTUnwrap(Bundle.typeformPreview.url(forResource: "MedicalIntake26", withExtension: "json"))
        let data = try Data(contentsOf: url)
        let form = try Self.decoder.decode(Typeform.Form.self, from: data)
        let field = try XCTUnwrap(form.field(withId: "0mMHJCj4JoPr"))
        guard case .statement(let statement) = field.properties else {
            XCTFail("Invalid Field")
            return
        }
        
        XCTAssertNotNil(statement.description)
        XCTAssertEqual(statement.button_text, "Acknowledge & Continue")
    }
}
