#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct StatementView: View {

    var properties: Statement
    var settings: Settings

    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }
        }
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
