#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct DropdownView: View {
    
    let reference: Reference
    let properties: Dropdown
    let settings: Settings
    var responses: Binding<Responses>
    var validations: Validations?
    var validated: Binding<Bool>?
    
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
            let entry = responses.wrappedValue[reference]
            switch entry {
            case .choice(let choice):
                selected = choice
            default:
                selected = nil
            }
            
            determineValidity()
        }
        .onChange(of: selected) { newValue in
            if let choice = newValue {
                responses.wrappedValue[reference] = .choice(choice)
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
        
        validated.wrappedValue = selected != nil
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownView(
            reference: .dropdown,
            properties: .preview,
            settings: Settings(),
            responses: .constant([:])
        )
    }
}
#endif
