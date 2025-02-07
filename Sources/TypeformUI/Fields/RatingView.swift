#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct RatingView: View {

    var state: Binding<ResponseState>
    var properties: Rating
    var settings: Settings
    var validations: Validations?

    @State private var value: Int?

    private var grid: [GridItem] {
        (0 ..< properties.steps).map { _ in GridItem(.flexible()) }
    }

    private var range: Range<Int> {
        .init(1 ... properties.steps)
    }

    private var outlinedImage: String {
        switch properties.shape.lowercased() {
        case "cloud": "cloud"
        default: "star"
        }
    }

    private var filledImage: String {
        switch properties.shape.lowercased() {
        case "cloud": "cloud.fill"
        default: "star.fill"
        }
    }

    var body: some View {
        LazyVGrid(columns: grid) {
            ForEach(range, id: \.self) { step in
                Button {
                    if value == step {
                        value = nil
                    } else {
                        value = step
                    }
                } label: {
                    VStack(alignment: .center) {
                        Image(systemName: (value ?? 0) >= step ? filledImage : outlinedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(color(forStep: step))
                            .padding([.leading, .trailing], 6)

                        Text("\(step)")
                            .font(settings.typography.promptFont)
                            .foregroundColor(settings.typography.promptColor)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            registerState()
        }
        .onChange(of: value) { _ in
            updateState()
        }
    }

    private func color(forStep step: Int) -> Color {
        (value ?? 0) >= step ? settings.rating.theme.selectedForegroundColor : settings.rating.theme.unselectedForegroundColor
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

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
