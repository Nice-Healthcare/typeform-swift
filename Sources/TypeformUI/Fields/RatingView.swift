#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct RatingView: View {
    
    let reference: Reference
    let properties: Rating
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
    @State private var value: Int?
    
    private var grid: [GridItem] {
        (0..<properties.steps).map { _ in GridItem(.flexible()) }
    }
    
    private var range: Range<Int> {
        .init(1...properties.steps)
    }
    
    private var outlinedImage: String {
        switch properties.shape.lowercased() {
        case "cloud": return "cloud"
        default: return "star"
        }
    }
    
    private var filledImage: String {
        switch properties.shape.lowercased() {
        case "cloud": return "cloud.fill"
        default: return "star.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                        VStack(alignment: .center) {
                            Image(systemName: (value ?? 0) >= step ? filledImage : outlinedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(color(forStep: step))
                                .padding([.leading, .trailing], 6)
                            
                            Text("\(step)")
                                .font(settings.typography.bodyFont)
                                .foregroundColor(settings.typography.bodyColor)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onAppear {
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .int(let int):
                value = int
            default:
                value = 0
            }
            
            determineValidity()
        }
        .onChange(of: value) { newValue in
            if let response = newValue {
                responses.wrappedValue[reference] = .int(response)
            } else {
                responses.wrappedValue[reference] = nil
            }
            
            determineValidity()
        }
    }
    
    private func color(forStep step: Int) -> Color {
        (value ?? 0) >= step ? settings.rating.selectedForegroundColor : settings.rating.unselectedForegroundColor
    }
    
    private func determineValidity() {
        guard let validated = self.validated else {
            return
        }
        
        guard let validations = validations, validations.required else {
            validated.wrappedValue = true
            return
        }
        
        validated.wrappedValue = value != nil
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(
            reference: .rating,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
