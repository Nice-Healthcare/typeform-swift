#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct StatementView: View {
    
    let reference: Reference
    let properties: Statement
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }
        }
        .onAppear {
            determineValidity()
        }
    }
    
    private func determineValidity() {
        guard let validated = self.validated else {
            return
        }
        
        guard let validations = validations, validations.required else {
            validated.wrappedValue = true
            return
        }
        
        validated.wrappedValue = true
    }
}

struct StatementView_Previews: PreviewProvider {
    static var previews: some View {
        StatementView(
            reference: .statement,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
