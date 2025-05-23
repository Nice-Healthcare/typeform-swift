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

    private var start: Int { properties.start_at_one ? 1 : 0 }
    private var end: Int { properties.start_at_one ? properties.steps : properties.steps - 1 }
    private var range: ClosedRange<Double> { Double(start - 1) ... Double(end) }
    private var sliderValue: String {
        if let value {
            "\(value)"
        } else {
            settings.localization.emptyChoice
        }
    }

    private var grid: [GridItem] { (0 ..< 6).map { _ in GridItem(.flexible()) } }
    private var leadingLabel: String {
        if let labels = properties.labels {
            String(format: "%d: %@", start, labels.leading)
        } else {
            String(format: "%d", start)
        }
    }

    private var trailingLabel: String {
        if let labels = properties.labels {
            String(format: "%d: %@", end, labels.trailing)
        } else {
            String(format: "%d", end)
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: settings.presentation.contentVerticalSpacing) {
            Text(sliderValue)
                .font(settings.typography.bodyFont)
                .foregroundColor(settings.typography.bodyColor)

            Slider(
                value: Binding(
                    get: {
                        if let value {
                            Double(value)
                        } else {
                            Double(start - 1)
                        }
                    }, set: { newValue in
                        if newValue == Double(start - 1) {
                            value = nil
                        } else {
                            value = Int(newValue)
                        }
                    }
                ),
                in: range,
                step: 1.0
            )

            HStack(alignment: .top) {
                Text(leadingLabel)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
                    .frame(width: 120, alignment: .leading)

                Spacer()

                Text(trailingLabel)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 120, alignment: .trailing)
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
