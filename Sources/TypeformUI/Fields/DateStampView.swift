#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct DateStampView: View {
    
    let reference: Reference
    let properties: DateStamp
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
    @State private var toggle: Bool = false
    @State private var value: Date = Date()
    
    private var isOptional: Bool {
        guard let required = validations?.required else {
            return true
        }
        
        return !required
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }
            
            VStack(spacing: settings.presentation.contentVerticalSpacing) {
                if isOptional {
                    Toggle(isOn: $toggle) {
                        Text(settings.localization.nullDate)
                            .font(settings.typography.bodyFont)
                            .foregroundColor(settings.typography.bodyColor)
                    }
                    .tint(.accentColor)
                }
                
                if !isOptional || !toggle {
                    HStack {
                        DatePicker("", selection: $value, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .disabled(toggle)
                    }
                }
            }
        }
        .onAppear {
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .date(let date):
                value = date
            default:
                value = Date()
            }
            
            determineValidity()
        }
        .onChange(of: toggle) { _ in
            if toggle {
                responses.wrappedValue[reference] = nil
            } else {
                responses.wrappedValue[reference] = .date(value)
            }
            
            determineValidity()
        }
        .onChange(of: value) { _ in
            if toggle {
                responses.wrappedValue[reference] = nil
            } else {
                responses.wrappedValue[reference] = .date(value)
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
        
        validated.wrappedValue = true
    }
}

struct DateStampView_Previews: PreviewProvider {
    static var previews: some View {
        DateStampView(
            reference: .date,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
