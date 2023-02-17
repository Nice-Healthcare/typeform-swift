#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct YesNoView: View {
    
    let reference: Reference
    let properties: YesNo
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
    @State private var selected: Bool?
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }
            
            VStack(spacing: settings.presentation.contentVerticalSpacing) {
                Button {
                    selected = (selected == true) ? nil : true
                } label: {
                    Text(settings.localization.yes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(ChoiceButtonStyle(
                    allowsMultipleSelection: false,
                    selected: selected == true,
                    settings: settings
                ))
                
                Button {
                    selected = (selected == false) ? nil : false
                } label: {
                    Text(settings.localization.no)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(ChoiceButtonStyle(
                    allowsMultipleSelection: false,
                    selected: selected == false,
                    settings: settings
                ))
            }
        }
        .onAppear {
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .bool(let bool):
                selected = bool
            default:
                selected = nil
            }
            
            determineValidity()
        }
        .onChange(of: selected) { newValue in
            if let response = newValue {
                responses.wrappedValue[reference] = .bool(response)
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
        
        validated.wrappedValue = selected != nil
    }
}

struct YesNoView_Previews: PreviewProvider {
    static var previews: some View {
        YesNoView(
            reference: .yesNo,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
