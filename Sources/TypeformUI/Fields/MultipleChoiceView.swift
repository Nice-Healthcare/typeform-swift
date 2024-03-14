#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct MultipleChoiceView: View {
    
    var state: Binding<ResponseState>
    var properties: MultipleChoice
    var settings: Settings
    var validations: Validations?
    
    @State private var selections: [Choice] = []
    
    private var choices: [Choice] {
        var choices = properties.choices
        if properties.randomize {
            choices.shuffle()
        }
        return choices
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.descriptionContentVerticalSpacing) {
            if let description = properties.description {
                Text(description)
                    .font(settings.typography.captionFont)
                    .foregroundColor(settings.typography.captionColor)
            }
            
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
                            .foregroundColor(settings.typography.bodyColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(
                        IntermittentChoiceButtonStyle(
                            allowsMultipleSelection: properties.allow_multiple_selection,
                            selected: selections.contains(choice),
                            settings: settings
                        )
                    )
                }
            }
        }
        .onAppear {
            registerState()
        }
        .onChange(of: selections) { _ in
            updateState()
        }
    }
    
    private func registerState() {
        switch state.wrappedValue.response {
        case .choice(let choice):
            selections = [choice]
        case .choices(let choices):
            selections = choices
        default:
            selections = []
        }
        
        updateState()
    }
    
    private func updateState() {
        var state = self.state.wrappedValue
        
        if properties.allow_multiple_selection {
            if !selections.isEmpty {
                state.response = .choices(selections)
            } else {
                state.response = nil
            }
        } else {
            if let choice = selections.first {
                state.response = .choice(choice)
            } else {
                state.response = nil
            }
        }
        
        if let validations = self.validations, validations.required {
            if properties.allow_multiple_selection {
                state.invalid = selections.isEmpty
            } else {
                state.invalid = selections.count != 1
            }
        } else {
            state.invalid = false
        }
        
        self.state.wrappedValue = state
    }
}

struct MultipleChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                MultipleChoiceView(
                    state: .constant(ResponseState()),
                    properties: .preview_One,
                    settings: Settings()
                )
                
                MultipleChoiceView(
                    state: .constant(ResponseState()),
                    properties: .preview_Many,
                    settings: Settings()
                )
            }
            .padding()
        }
    }
}
#endif
