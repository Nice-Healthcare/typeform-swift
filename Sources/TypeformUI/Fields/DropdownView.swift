#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct DropdownView: View {
    
    var state: Binding<ResponseState>
    var properties: Dropdown
    var settings: Settings
    var validations: Validations?
    
    @State private var selected: Choice?
    
    private var choices: [Choice] {
        var choices = properties.choices
        if properties.alphabetical_order {
            choices.sort(by: { $0.label < $1.label })
        }
        if properties.randomize {
            choices.shuffle()
        }
        return choices
    }
    
    var body: some View {
        Picker(selection: $selected) {
            Text(settings.localization.emptyChoice)
                .tag(Choice?.none)
            
            ForEach(choices) { choice in
                Text(choice.label)
                    .tag(Choice?.some(choice))
            }
        } label: {
            Text(selected?.label ?? settings.localization.emptyChoice)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .fieldStyle(settings: settings)
        .onAppear {
            registerState()
        }
        .onChange(of: selected) { _ in
            updateState()
        }
    }
    
    private func registerState() {
        switch state.wrappedValue.response {
        case .choice(let choice):
            selected = choice
        default:
            selected = nil
        }
        
        updateState()
    }
    
    private func updateState() {
        var state = self.state.wrappedValue
        
        if let choice = selected {
            state.response = .choice(choice)
        } else {
            state.response = nil
        }
        
        if let validations = self.validations, validations.required {
            state.invalid = selected == nil
        } else {
            state.invalid = false
        }
        
        self.state.wrappedValue = state
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownView(
            state: .constant(ResponseState()),
            properties: .preview,
            settings: Settings()
        )
    }
}
#endif
