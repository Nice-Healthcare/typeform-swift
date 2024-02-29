#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct OpinionScaleView: View {
    
    var state: Binding<ResponseState>
    var properties: OpinionScale
    var settings: Settings
    var validations: Validations?
    
    @State private var value: Int?
    
    private var range: Range<Int> {
        let start = properties.start_at_one ? 1 : 0
        let end = properties.start_at_one ? properties.steps : properties.steps - 1
        return Range(start...end)
    }
    
    private var grid: [GridItem] {
        (0..<6).map { _ in GridItem(.flexible()) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            HStack(alignment: .top) {
                Text(properties.labels.leading)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
                
                Spacer()
                
                Text(properties.labels.trailing)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }
            
            LazyVGrid(columns: grid) {
                ForEach(range, id: \.self) { step in
                    Button {
                        if value == step {
                            value = nil
                        } else {
                            value = step
                        }
                    } label: {
                        Text("\(step)")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(
                        IntermittentChoiceButtonStyle(
                            style: nil,
                            selected: value == step,
                            settings: settings
                        )
                    )
                }
            }
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
        case .int(let int):
            value = int
        default:
            value = nil
        }
        
        updateState()
    }
    
    private func updateState() {
        var state = self.state.wrappedValue
        
        if let response = value {
            state.response = .int(response)
        } else {
            state.response = nil
        }
        
        if let validations = self.validations, validations.required {
            state.invalid = value == nil
        } else {
            state.invalid = false
        }
        
        self.state.wrappedValue = state
    }
}

struct OpinionScaleView_Previews: PreviewProvider {
    static var previews: some View {
        OpinionScaleView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
