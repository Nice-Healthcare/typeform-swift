#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct LongTextView: View {
    
    let reference: Reference
    let properties: LongText
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
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
            .frame(idealHeight: 200, maxHeight: 200)
            .overlay(
                shape.stroke(settings.field.strokeColor, lineWidth: settings.field.strokeWidth)
            )
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

struct LongTextView_Previews: PreviewProvider {
    static var previews: some View {
        LongTextView(
            reference: .longText,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
