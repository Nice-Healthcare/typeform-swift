#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct StatementView: View {

    var properties: Statement
    var settings: Settings

    var body: some View {
        EmptyView()
    }
}

struct StatementView_Previews: PreviewProvider {
    static var previews: some View {
        StatementView(
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
