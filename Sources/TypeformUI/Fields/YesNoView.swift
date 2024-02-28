#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct YesNoView: View {
    
    var state: Binding<ResponseState>
    var properties: YesNo
    var settings: Settings
    var validations: Validations?
    
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
                .buttonStyle(IntermittentChoiceButtonStyle(
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
                .buttonStyle(IntermittentChoiceButtonStyle(
                    allowsMultipleSelection: false,
                    selected: selected == false,
                    settings: settings
                ))
            }
        }
        .onAppear {
            registerState()
        }
        .onChange(of: selected) { _ in
            updateState()
        }
    }
    
    private func registerState() {
        switch state.wrappedValue.response {
        case .bool(let bool):
            selected = bool
        default:
            selected = nil
        }
        
        updateState()
    }
    
    private func updateState() {
        var state = self.state.wrappedValue
        
        if let response = selected {
            state.response = .bool(response)
        } else {
            state.response = nil
        }
        
        if let validations = self.validations, validations.required {
            state.invalid = selected == nil
        } else {
            state.invalid = false
        }
        
        self.state.wrappedValue = state
    }
}

struct YesNoView_Previews: PreviewProvider {
    static var previews: some View {
        YesNoView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
