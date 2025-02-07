#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct AttachmentView: View {

    let attachment: Attachment

    var body: some View {
        AsyncImage(url: attachment.href)
            .aspectRatio(contentMode: .fit)
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
