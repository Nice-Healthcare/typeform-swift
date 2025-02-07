#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct ScreenView<Header: View, Footer: View>: View {
    
    let form: Typeform.Form
    let screen: any Screen
    let settings: Settings
    let responses: Responses
    let conclusion: (Conclusion) -> Void
    let header: () -> Header
    let footer: () -> Footer
    
    @State private var next: Position?
    
    private var isWelcome: Bool {
        switch screen {
        case is WelcomeScreen:
            return true
        default:
            return false
        }
    }
    
    private var showImage: Bool {
        isWelcome ? settings.presentation.showWelcomeImage : settings.presentation.showEndingImage
    }
    
    init(
        form: Typeform.Form,
        screen: any Screen,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.screen = screen
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        self.header = header
        self.footer = footer
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: settings.presentation.titleDescriptionVerticalSpacing) {
                    if let attachment = screen.attachment, showImage {
                        AsyncImage(url: attachment.href) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(screen.title)
                        .font(settings.typography.titleFont)
                        .foregroundColor(settings.typography.titleColor)
                    
                    if settings.presentation.layout == .inline {
                        if let next = self.next {
                            navigation(next: next)
                        }
                        
                        if !isWelcome {
                            Button {
                                conclusion(.completed(responses, screen as! EndingScreen))
                            } label: {
                                Text(settings.localization.finish)
                            }
                        }
                    }
                }
                .padding(settings.presentation.contentInsets)
            }
            
            if settings.presentation.layout == .callToAction {
                VStack(spacing: settings.callToAction.verticalSpacing) {
                    Divider()
                        .foregroundColor(settings.callToAction.dividerColor)
                    
                    if let next = self.next {
                        navigation(next: next)
                            .padding(settings.callToAction.insets)
                    }
                    
                    if !isWelcome {
                        Button {
                            conclusion(.completed(responses, screen as! EndingScreen))
                        } label: {
                            Text(settings.localization.finish)
                        }
                        .padding(settings.callToAction.insets)
                    }
                }
                .background(settings.callToAction.backgroundColor)
            }
        }
        .background(settings.presentation.backgroundColor)
        #if os(iOS)
        .navigationBarBackButtonHidden()
        #endif
        .onAppear {
            next = try? form.next(from: .screen(screen), given: responses)
            if !isWelcome && settings.presentation.skipEndingScreen {
                conclusion(.completed(responses, screen as! EndingScreen))
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if isWelcome {
                    Button {
                        conclusion(.canceled)
                    } label: {
                        Text(settings.localization.exit)
                    }
                    .buttonStyle(.borderless)
                }
                
                if settings.presentation.layout == .navigation {
                    if let next = self.next {
                        navigation(next: next)
                            .buttonStyle(.borderless)
                    }
                    
                    if !isWelcome {
                        Button {
                            conclusion(.completed(responses, screen as! EndingScreen))
                        } label: {
                            Text(settings.localization.finish)
                        }
                    }
                }
            }
        }
    }
    
    private func navigation(next: Position) -> some View {
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
            }
        } label: {
            Text(screen.properties.button_text ?? settings.localization.next)
        }
    }
}

extension ScreenView where Footer == EmptyView {
    init(
        form: Typeform.Form,
        screen: any Screen,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.form = form
        self.screen = screen
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        self.header = header
        self.footer = { Footer() }
    }
}

extension ScreenView where Header == EmptyView {
    init(
        form: Typeform.Form,
        screen: any Screen,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.form = form
        self.screen = screen
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = footer
    }
}

extension ScreenView where Footer == EmptyView, Header == EmptyView {
    init(
        form: Typeform.Form,
        screen: any Screen,
        settings: Settings,
        responses: Responses,
        conclusion: @escaping (Conclusion) -> Void
    ) {
        self.form = form
        self.screen = screen
        self.settings = settings
        self.responses = responses
        self.conclusion = conclusion
        self.header = { Header() }
        self.footer = { Footer() }
    }
}

#Preview("Welcome Screen") {
    NavigationView {
        ScreenView(
            form: .medicalIntake23,
            screen: WelcomeScreen.preview,
            settings: Settings(),
            responses: [:],
            conclusion: { _ in }
        )
    }
}

#Preview("Thank You Screen") {
    NavigationView {
        ScreenView(
            form: .medicalIntake23,
            screen: EndingScreen.preview,
            settings: Settings(),
            responses: [:],
            conclusion: { _ in }
        )
    }
}
#endif
