#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct FieldView<Header: View, Footer: View>: View {
    
    @Binding var responses: Responses
    let form: Typeform.Form
    let field: Field
    let group: Typeform.Group?
    let settings: Settings
    let conclusion: (Conclusion) -> Void
    let header: () -> Header
    let footer: () -> Footer
    
    @State private var validated: Bool = false
    @State private var next: Position?
    @State private var cancel: Bool = false
    
    private var nextTitle: String {
        switch field.properties {
        case .group(let group):
            return group.button_text
        case .statement(let statement):
            return statement.button_text
        default:
            return settings.localization.next
        }
    }
    
    init(
        responses: Binding<Responses>,
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        _responses = responses
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = header
        self.footer = footer
    }
    
    private var titleFont: Font { field.type == .group ? settings.typography.titleFont : settings.typography.promptFont }
    
    var body: some View {
        VStack(spacing: 0) {
            header()
            
            ScrollView {
                VStack(alignment: .leading, spacing: settings.presentation.titleDescriptionVerticalSpacing) {
                    Text(field.title)
                        .font(titleFont)
                        .foregroundColor(settings.typography.promptColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    switch field.properties {
                    case .date(let properties):
                        DateStampView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .dropdown(let properties):
                        DropdownView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .group:
                        EmptyView()
                    case .longText(let properties):
                        LongTextView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .multipleChoice(let properties):
                        MultipleChoiceView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .number(let properties):
                        NumberView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .rating(let properties):
                        RatingView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .shortText(let properties):
                        ShortTextView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    case .statement:
                        EmptyView()
                    case .yesNo(let properties):
                        YesNoView(
                            reference: field.ref,
                            properties: properties,
                            settings: settings,
                            responses: $responses,
                            validations: field.validations,
                            validated: $validated
                        )
                    }
                    
                    if settings.presentation.layout == .inline {
                        navigation(next: next)
                    }
                }
                .padding(settings.presentation.contentInsets)
            }
            
            VStack(spacing: settings.callToAction.verticalSpacing) {
                if settings.presentation.layout == .callToAction {
                    Divider()
                        .foregroundColor(settings.callToAction.dividerColor)
                    
                    navigation(next: next)
                        .padding(settings.callToAction.insets)
                }
                
                footer()
            }
            .background(
                settings.callToAction.backgroundColor
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .background(settings.presentation.backgroundColor)
        .onAppear {
            determineNext()
        }
        .onChange(of: validated) { _ in
            determineNext()
        }
        .onChange(of: responses) { _ in
            determineNext()
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    if settings.presentation.skipWelcomeScreen && responses.isEmpty {
                        conclusion(.canceled)
                    } else {
                        cancel = true
                    }
                } label: {
                    Text(settings.localization.cancel)
                }
                .buttonStyle(.borderless)
                
                if settings.presentation.layout == .navigation {
                    navigation(next: next)
                        .buttonStyle(.borderless)
                }
            }
        }
        .alert(settings.localization.abandonConfirmationTitle, isPresented: $cancel) {
            Button(settings.localization.cancel, role: .cancel) {
                cancel = false
            }
            
            Button(settings.localization.abandonConfirmationAction, role: .destructive) {
                cancel = false
                conclusion(.abandoned(responses))
            }
        } message: {
            Text(settings.localization.abandonConfirmationMessage)
        }
    }
    
    private func determineNext() {
        next = try? form.next(from: .field(field, group), given: responses)
    }
    
    private func navigation(next: Position?) -> some View {
        NavigationLink {
            switch next {
            case .field(let field, let group):
                FieldView(
                    responses: $responses,
                    form: form,
                    field: field,
                    group: group,
                    settings: settings,
                    conclusion: conclusion,
                    header: header,
                    footer: footer
                )
            case .screen(let screen):
                ScreenView(
                    responses: $responses,
                    form: form,
                    screen: screen,
                    settings: settings,
                    conclusion: conclusion,
                    header: header,
                    footer: footer
                )
            case .none:
                RejectedView(
                    responses: $responses,
                    form: form,
                    settings: settings,
                    conclusion: conclusion
                )
            }
        } label: {
            Text(nextTitle)
        }
        .disabled(next == nil && !validated)
    }
}

extension FieldView where Footer == EmptyView {
    init(
        responses: Binding<Responses>,
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header
    ) {
        _responses = responses
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = header
        self.footer = { Footer() }
    }
}

extension FieldView where Header == EmptyView {
    init(
        responses: Binding<Responses>,
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        _responses = responses
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = footer
    }
}

extension FieldView where Footer == EmptyView, Header == EmptyView {
    init(
        responses: Binding<Responses>,
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        conclusion: @escaping (Conclusion) -> Void
    ) {
        _responses = responses
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = { Footer() }
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                FieldView(
                    responses: .constant([:]),
                    form: .medicalIntake23,
                    field: .field(withRef: .multipleChoice_One),
                    group: nil,
                    settings: Settings(),
                    conclusion: { _ in }
                )
            }
        }
    }
}
#endif
