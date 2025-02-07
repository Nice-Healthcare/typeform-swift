#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

public struct FormView<Header: View, Footer: View>: View {

    let form: Typeform.Form
    let settings: Settings
    let responses: Responses
    let conclusion: (Conclusion) -> Void
    let header: () -> Header
    let footer: () -> Footer

    /// Launching point for a **Typeform** `Form`.
    ///
    /// - parameters:
    ///   - form: The `Form` which should be navigated.
    ///   - settings: Presentation and localization settings used to configure the form display.
    ///   - responses: A response map with answers to questions asked by the form. These fields will be skipped.
    ///   - conclusion: Callback function that will be executed at the termination of the form display.
    ///   - header: A `View` which will be displayed above the form content.
    ///   - footer: A `View` which will be displayed below the form content.
    public init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        responses: Responses = [:],
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        self.header = header
        self.footer = footer
    }

    public var body: some View {
        NavigationView {
            ZStack {
                if let position = try? form.firstPosition(skipWelcomeScreen: settings.presentation.skipWelcomeScreen, given: responses) {
                    switch position {
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
                    }
                } else {
                    RejectedView(
                        form: form,
                        settings: settings,
                        responses: responses,
                        conclusion: conclusion
                    )
                }
            }
            #if os(iOS) || os(watchOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

public extension FormView where Footer == EmptyView {
    init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        responses: Responses = [:],
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.form = form
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        self.header = header
        footer = { Footer() }
    }
}

public extension FormView where Header == EmptyView {
    init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        responses: Responses = [:],
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        header = { Header() }
        self.footer = footer
    }
}

public extension FormView where Footer == EmptyView, Header == EmptyView {
    init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        responses: Responses = [:],
        conclusion: @escaping (Conclusion) -> Void
    ) {
        self.form = form
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        header = { Header() }
        footer = { Footer() }
    }
}

#Preview("Form View") {
    FormView(
        form: .medicalIntake35,
        responses: [
            .string("appointment-state"): .choice(
                Choice(
                    id: "0H6r4PQIWFI6",
                    ref: .uuid(UUID(uuidString: "aa028c7c-ce34-428f-8563-35bce5201dc1")!),
                    label: "Minnesota"
                )
            ),
        ],
        conclusion: { _ in }
    )
}
#endif
