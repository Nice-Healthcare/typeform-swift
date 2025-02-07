#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct NumberView: View {

    var state: Binding<ResponseState>
    var properties: Number
    var settings: Settings
    var validations: Validations?

    @State private var value: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }

            TextField("", value: $value, format: .number)
            #if os(iOS) || os(tvOS)
                .keyboardType(.numberPad)
            #endif
                .fieldStyle(settings: settings)
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
        var state = state.wrappedValue

        if let response = value {
            state.response = .int(response)
        } else {
            state.response = nil
        }

        if let validations, validations.required {
            state.invalid = value == nil
        } else {
            state.invalid = false
        }

        self.state.wrappedValue = state
    }
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
        NumberView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
