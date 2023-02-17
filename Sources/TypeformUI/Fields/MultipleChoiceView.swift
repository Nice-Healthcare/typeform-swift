#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct MultipleChoiceView: View {
    
    let reference: Reference
    let properties: MultipleChoice
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
    @State private var selections: [Choice] = []
    
    private var choices: [Choice] {
        var choices = properties.choices
        if properties.randomize {
            choices.shuffle()
        }
        return choices
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.contentVerticalSpacing) {
            ForEach(choices) { choice in
                Button {
                    if properties.allow_multiple_selection {
                        if let index = selections.firstIndex(of: choice) {
                            selections.remove(at: index)
                        } else {
                            selections.append(choice)
                        }
                    } else {
                        selections = [choice]
                    }
                } label: {
                    Text(choice.label)
                        .font(settings.typography.bodyFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(ChoiceButtonStyle(
                    allowsMultipleSelection: properties.allow_multiple_selection,
                    selected: selections.contains(choice),
                    settings: settings
                ))
            }
        }
        .onAppear {
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .choices(let choices):
                selections = choices
            default:
                selections = []
            }
            
            determineValidity()
        }
        .onChange(of: selections) { newValue in
            if !newValue.isEmpty {
                responses.wrappedValue[reference] = .choices(selections)
            } else {
                responses.wrappedValue[reference] = nil
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
        
        if properties.allow_multiple_selection {
            validated.wrappedValue = !selections.isEmpty
        } else {
            validated.wrappedValue = selections.count == 1
        }
    }
}

struct MultipleChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                MultipleChoiceView(
                    reference: .multipleChoice_One,
                    properties: .preview_One,
                    settings: Settings(),
                    responses: .constant([:])
                )
                
                MultipleChoiceView(
                    reference: .multipleChoice_Many,
                    properties: .preview_Many,
                    settings: Settings(),
                    responses: .constant([:])
                )
            }
            .padding()
        }
    }
}
#endif
