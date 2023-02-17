#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct RejectedView: View {
    
    @Binding var responses: Responses
    let form: Typeform.Form
    let settings: Settings
    let conclusion: (Conclusion) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50.0)
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 40)
                    
                    if settings.presentation.layout == .inline {
                        Button {
                            conclusion(.rejected(responses))
                        } label: {
                            Text(settings.localization.finish)
                        }
                    }
                }
                .padding(settings.presentation.contentInsets)
            }
            
            if settings.presentation.layout == .callToAction {
                VStack(spacing: settings.callToAction.verticalSpacing) {
                    Divider()
                        .foregroundColor(settings.callToAction.dividerColor)
                    
                    Button {
                        conclusion(.rejected(responses))
                    } label: {
                        Text(settings.localization.finish)
                    }
                    .padding(settings.callToAction.insets)
                }
                .background(settings.callToAction.backgroundColor)
            }
        }
        .background(settings.presentation.backgroundColor)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if settings.presentation.layout == .navigation {
                    Button {
                        conclusion(.rejected(responses))
                    } label: {
                        Text(settings.localization.finish)
                    }
                }
            }
        }
    }
}

struct RejectedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RejectedView(
                responses: .constant([:]),
                form: .medicalIntake23,
                settings: Settings(),
                conclusion: { _ in }
            )
        }
    }
}
#endif
