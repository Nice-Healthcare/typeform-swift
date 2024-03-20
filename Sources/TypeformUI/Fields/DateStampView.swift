#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct DateStampView: View {
    
    var state: Binding<ResponseState>
    var properties: DateStamp
    var settings: Settings
    var validations: Validations?
    
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
                            .font(settings.typography.promptFont)
                            .foregroundColor(settings.typography.promptColor)
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
            registerState()
        }
        .onChange(of: toggle) { _ in
            updateState()
        }
        .onChange(of: value) { _ in
            updateState()
        }
    }
    
    private func registerState() {
        switch state.wrappedValue.response {
        case .date(let date):
            value = date
        default:
            value = Date()
        }
        
        updateState()
    }
    
    private func updateState() {
        var state = self.state.wrappedValue
        
        if toggle {
            state.response = nil
        } else {
            state.response = .date(value)
        }
        
        if let validations = self.validations, validations.required {
            state.invalid = state.response == nil
        } else {
            state.invalid = false
        }
        
        self.state.wrappedValue = state
    }
}

struct DateStampView_Previews: PreviewProvider {
    static var previews: some View {
        DateStampView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
