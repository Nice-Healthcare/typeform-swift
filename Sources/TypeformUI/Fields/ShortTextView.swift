#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct ShortTextView: View {
    
    let reference: Reference
    let properties: ShortText
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    var focused: FocusState<Bool>.Binding
    
    @State private var value: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
            }
            
            TextField("", text: $value)
                .fieldStyle(settings: settings)
                .focused(focused)
        }
        .onAppear {
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .string(let string):
                value = string
            default:
                value = ""
            }
            
            determineValidity()
        }
        .onChange(of: value) { newValue in
            if newValue.isEmpty {
                responses.wrappedValue[reference] = nil
            } else {
                responses.wrappedValue[reference] = .string(newValue)
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
        
        validated.wrappedValue = !value.isEmpty
    }
}

struct ShortTextView_Previews: PreviewProvider {
    @FocusState static var focused: Bool
    static var previews: some View {
        ShortTextView(
            reference: .shortText,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:]),
            focused: $focused
        )
    }
}
#endif
