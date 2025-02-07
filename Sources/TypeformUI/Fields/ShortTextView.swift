#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct ShortTextView: View {

    var state: Binding<ResponseState>
    var properties: ShortText
    var settings: Settings
    var validations: Validations?
    var focused: FocusState<Bool>.Binding

    @State private var value: String = ""

    var body: some View {
        TextField("", text: $value)
            .fieldStyle(settings: settings)
            .focused(focused)
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
        var state = state.wrappedValue

        if value.isEmpty {
            state.response = nil
        } else {
            state.response = .string(value)
        }

        if let validations, validations.required {
            state.invalid = value.isEmpty
        } else {
            state.invalid = false
        }

        self.state.wrappedValue = state
    }
}

struct ShortTextView_Previews: PreviewProvider {
    @FocusState static var focused: Bool
    static var previews: some View {
        ShortTextView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings(),
            focused: $focused
        )
    }
}
#endif
