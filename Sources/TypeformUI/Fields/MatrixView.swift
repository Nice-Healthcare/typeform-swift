#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct MatrixView: View {

    var state: Binding<ResponseState>
    var properties: Matrix
    var settings: Settings
    var validations: Validations?

    @State private var selections: [Reference: [Choice]] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: settings.presentation.contentVerticalSpacing) {
            Grid {
                GridRow {
                    Text("")
                    ForEach(properties.columns, id: \.self) { column in
                        Text(column)
                            .font(settings.typography.bodyFont)
                            .foregroundColor(settings.typography.bodyColor)
                    }
                }

                ForEach(properties.questions) { iteration in
                    Divider()

                    GridRow {
                        Text(iteration.title)
                            .font(settings.typography.bodyFont)
                            .foregroundColor(settings.typography.bodyColor)
                            .frame(maxWidth: .infinity, alignment: .trailing)

                        ForEach(iteration.question.choices) { choice in
                            Button {
                                var choices = selections[iteration.ref] ?? []
                                if properties.allow_multiple_selections {
                                    if let index = choices.firstIndex(of: choice) {
                                        choices.remove(at: index)
                                    } else {
                                        choices.append(choice)
                                    }
                                } else {
                                    choices = [choice]
                                }
                                selections[iteration.ref] = choices
                            } label: {}
                                .buttonStyle(
                                    IntermittentChoiceButtonStyle(
                                        allowsMultipleSelection: properties.allow_multiple_selections,
                                        selected: selections[iteration.ref]?.contains(choice) ?? false,
                                        settings: settings,
                                    ),
                                )
                        }
                    }
                    .multilineTextAlignment(.trailing)
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
        case .choicesByReference(let dictionary):
            selections = dictionary
        default:
            selections = properties.questions.reduce(into: [Reference: [Choice]]()) { partialResult, iteration in
                partialResult.updateValue([], forKey: iteration.ref)
            }
        }

        updateState()
    }

    private func updateState() {
        var state = state.wrappedValue

        if selections.values.contains(where: { !$0.isEmpty }) {
            state.response = .choicesByReference(selections)
        } else {
            state.response = nil
        }

        if let validations, validations.required {
            if properties.allow_multiple_selections {
                state.invalid = selections.values.contains(where: \.isEmpty)
            } else {
                state.invalid = selections.values.contains(where: { $0.count != 1 })
            }
        } else {
            state.invalid = false
        }

        self.state.wrappedValue = state
    }
}

#Preview {
    ScrollView {
        MatrixView(
            state: .constant(ResponseState()),
            properties: {
                let form = try! Bundle.typeformPreview.decode(Typeform.Form.self, forResource: "MatrixExample")
                let field = form.field(withId: "3LifzqG22m1P")!
                guard case .matrix(let matrix) = field.properties else {
                    fatalError()
                }

                return matrix
            }(),
            settings: Settings(),
        )
        .padding()
    }
}
#endif
