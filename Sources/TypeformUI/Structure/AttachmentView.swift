#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct AttachmentView: View {

    let attachment: Attachment

    var body: some View {
        AsyncImage(url: attachment.href) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .accessibilityLabel(Text(attachment.properties?.description ?? "No Image Description"))
            case .failure(let error):
                Text(error.localizedDescription)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview("Attachment View") {
    AttachmentView(
        attachment: Attachment(
            href: URL(string: "https://images.typeform.com/images/aiEV7G3rFMzd")!
        )
    )
}
#endif
