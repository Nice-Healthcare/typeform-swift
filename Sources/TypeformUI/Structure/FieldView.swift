#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct FieldView<Header: View, Footer: View>: View {
    
    let form: Typeform.Form
    let field: Field
    let group: Typeform.Group?
    let settings: Settings
    let conclusion: (Conclusion) -> Void
    let header: () -> Header
    let footer: () -> Footer
    
    @State private var responseState: ResponseState
    @State private var responses: Responses
    @State private var next: Position?
    @State private var cancel: Bool = false
    @FocusState private var focused: Bool
    
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
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = header
        self.footer = footer
        _responseState = .init(initialValue: ResponseState(for: field, given: responses))
        _responses = .init(initialValue: responses)
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
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
                        )
                    case .dropdown(let properties):
                        DropdownView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
                        )
                    case .group:
                        EmptyView()
                    case .longText(let properties):
                        LongTextView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations,
                            focused: $focused
                        )
                    case .multipleChoice(let properties):
                        MultipleChoiceView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
                        )
                    case .number(let properties):
                        NumberView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
                        )
                    case .opinionScale(let properties):
                        OpinionScaleView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
                        )
                    case .rating(let properties):
                        RatingView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
                        )
                    case .shortText(let properties):
                        ShortTextView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations,
                            focused: $focused
                        )
                    case .statement(let properties):
                        StatementView(
                            properties: properties,
                            settings: settings
                        )
                    case .yesNo(let properties):
                        YesNoView(
                            state: $responseState,
                            properties: properties,
                            settings: settings,
                            validations: field.validations
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
        .onChange(of: responseState) { newValue in
            responses[field.ref] = newValue.response
            determineNext()
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    focused = false
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
                    form: form,
                    field: field,
                    group: group,
                    settings: settings,
                    responses: responses,
                    conclusion: conclusion,
                    header: header,
                    footer: footer
                )
            case .screen(let screen):
                ScreenView(
                    form: form,
                    screen: screen,
                    settings: settings,
                    responses: responses,
                    conclusion: conclusion,
                    header: header,
                    footer: footer
                )
            case .none:
                RejectedView(
                    form: form,
                    settings: settings,
                    responses: responses,
                    conclusion: conclusion
                )
            }
        } label: {
            Text(nextTitle)
        }
        .disabled(next == nil || responseState.invalid)
    }
}

extension FieldView where Footer == EmptyView {
    init(
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = header
        self.footer = { Footer() }
        _responseState = .init(initialValue: ResponseState(for: field, given: responses))
        _responses = .init(initialValue: responses)
    }
}

extension FieldView where Header == EmptyView {
    init(
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = footer
        _responseState = .init(initialValue: ResponseState(for: field, given: responses))
        _responses = .init(initialValue: responses)
    }
}

extension FieldView where Footer == EmptyView, Header == EmptyView {
    init(
        form: Typeform.Form,
        field: Field,
        group: Typeform.Group?,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void
    ) {
        self.form = form
        self.field = field
        self.group = group
        self.settings = settings
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = { Footer() }
        _responseState = .init(initialValue: ResponseState(for: field, given: responses))
        _responses = .init(initialValue: responses)
    }
}

#if swift(>=5.9)
#Preview("Field View") {
    NavigationView {
        VStack {
            FieldView(
                form: .medicalIntake23,
                field: .field(withRef: .multipleChoice_One),
                group: nil,
                settings: Settings(),
                responses: [
                    .multipleChoice_One: .choice(
                        Choice(
                            id: "Sx6ZqqmkAHOI",
                            ref: Reference(uuidString: "4f6732f3-d3b6-4c83-9c3e-a4945a004507")!,
                            label: "An update or follow-up on how you are feeling regarding an illness or injury that was discussed with a Specialty medical provider"
                        )
                    )
                ],
                conclusion: { _ in }
            )
        }
    }
}
#endif
#endif
