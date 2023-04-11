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
        XCTAssertEqual(json, """
        {
          "_links" : {
            "display" : "https:\\/\\/www.typeform.com"
          },
          "created_at" : "0001-01-01T00:00:00+00:00",
          "fields" : [

          ],
          "hidden" : [

          ],
          "id" : "",
          "last_updated_at" : "0001-01-01T00:00:00+00:00",
          "logic" : [

          ],
          "published_at" : "0001-01-01T00:00:00+00:00",
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
}
