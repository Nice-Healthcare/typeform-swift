#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

public struct FormView<Header: View, Footer: View>: View {
    
    let form: Typeform.Form
    let settings: Settings
    let conclusion: (Conclusion) -> Void
    let header: () -> Header
    let footer: () -> Footer
    
    @State private var responses: Responses = [:]
    
    public init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.settings = settings
        self.conclusion = conclusion
        self.header = header
        self.footer = footer
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                if let screen = form.firstScreen, settings.presentation.skipWelcomeScreen == false {
                    ScreenView(
                        responses: $responses,
                        form: form,
                        screen: screen,
                        settings: settings,
                        conclusion: conclusion,
                        header: header,
                        footer: footer
                    )
                } else if let field = form.fields.first, settings.presentation.skipWelcomeScreen {
                    FieldView(
                        responses: $responses,
                        form: form,
                        field: field,
                        group: nil,
                        settings: settings,
                        conclusion: conclusion,
                        header: header,
                        footer: footer
                    )
                } else {
                    RejectedView(
                        responses: $responses,
                        form: form,
                        settings: settings,
                        conclusion: conclusion
                    )
                }
            }
        }
    }
}

public extension FormView where Footer == EmptyView {
    init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.form = form
        self.settings = settings
        self.conclusion = conclusion
        self.header = header
        self.footer = { Footer() }
    }
}

public extension FormView where Header == EmptyView {
    init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.settings = settings
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = footer
    }
}

public extension FormView where Footer == EmptyView, Header == EmptyView {
    init(
        form: Typeform.Form,
        settings: Settings = Settings(),
        conclusion: @escaping (Conclusion) -> Void
    ) {
        self.form = form
        self.settings = settings
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = { Footer() }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(
            form: .medicalIntake23,
            conclusion: { _ in }
        )
    }
}
#endif
