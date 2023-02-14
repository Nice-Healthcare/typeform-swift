#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct NumberView: View {
    
    let reference: Reference
    let properties: Number
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
    @State private var value: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
            }
            
            TextField("", value: $value, format: .number)
                .fieldStyle(settings: settings)
        }
        .onAppear {
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .int(let int):
                value = int
            default:
                value = nil
            }
            
            determineValidity()
        }
        .onChange(of: value) { newValue in
            if let response = newValue {
                responses.wrappedValue[reference] = .int(response)
            } else {
                responses.wrappedValue[reference] = nil
            }
            
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
        
        validated.wrappedValue = value != nil
    }
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
        NumberView(
            reference: .number,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
