#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct LongTextView: View {
    
    var state: Binding<ResponseState>
    var properties: LongText
    var settings: Settings
    var validations: Validations?
    var focused: FocusState<Bool>.Binding
    
    @State private var value: String = ""
    
    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: settings.field.cornerRadius) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
            }
            
            ZStack {
                settings.field.backgroundColor.clipShape(shape)
                
                if #available(iOS 16.0, macOS 13.0, *) {
                    TextEditor(text: $value)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, settings.field.horizontalInset)
                        .padding(.vertical, settings.field.verticalInset)
                } else {
                    TextEditor(text: $value)
                        .padding(.horizontal, settings.field.horizontalInset)
                        .padding(.vertical, settings.field.verticalInset)
                        #if canImport(UIKit)
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }
                        .onDisappear {
                            UITextView.appearance().backgroundColor = nil
                        }
                        #endif
                }
            }
            .focused(focused)
            .frame(idealHeight: 200, maxHeight: 200)
            .overlay(
                shape.stroke(settings.field.strokeColor, lineWidth: settings.field.strokeWidth)
            )
        }
        .onAppear {
            registerState()
        }
        .onChange(of: value) { _ in
            updateState()
        }
    }
    
    private func registerState() {
        switch state.wrappedValue.response {
        case .string(let string):
            value = string
        default:
            value = ""
        }
        
        updateState()
    }
    
    private func updateState() {
        var state = self.state.wrappedValue
        
        if value.isEmpty {
            state.response = nil
        } else {
            state.response = .string(value)
        }
        
        if let validations = self.validations, validations.required {
            state.invalid = value.isEmpty
        } else {
            state.invalid = false
        }
        
        self.state.wrappedValue = state
    }
}

struct LongTextView_Previews: PreviewProvider {
    @FocusState static var focused: Bool
    static var previews: some View {
        LongTextView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings(),
            focused: $focused
        )
    }
}
#endif
