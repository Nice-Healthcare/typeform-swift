#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct UploadImageView: View {

    var upload: Upload
    var settings: Settings
    var removeAction: () -> Void = {}

    private let padding = EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                #if canImport(UIKit)
                if let image = UIImage(data: upload.bytes) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(
                            RoundedRectangle(cornerRadius: settings.upload.imageRadius),
                        )
                        .padding(padding)
                } else {
                    UploadPlaceholderView(
                        settings: settings,
                        padding: padding,
                    )
                }
                #elseif canImport(AppKit)
                if let image = NSImage(data: upload.bytes) {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(
                            RoundedRectangle(cornerRadius: settings.upload.imageRadius),
                        )
                        .padding(padding)
                } else {
                    UploadPlaceholderView(
                        settings: settings,
                        padding: padding,
                    )
                }
                #endif

                Button {
                    removeAction()
                } label: {
                    Label("Remove", systemImage: "x.circle.fill")
                        .labelStyle(.iconOnly)
                        .background(settings.radio.theme.selectedBackgroundColor)
                        .foregroundStyle(settings.radio.theme.selectedForegroundColor)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: settings.upload.imageMaxWidth)

            Text(upload.fileName)
                .font(settings.typography.captionFont)
                .foregroundStyle(settings.typography.captionColor)
                .padding(.leading, padding.leading)
        }
    }
}

struct UploadPlaceholderView: View {

    var settings: Settings
    var padding: EdgeInsets

    private var glyphWidth: CGFloat {
        if let width = settings.upload.imageMaxWidth {
            width * 0.3
        } else {
            60
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(settings.upload.placeholderBackgroundColor)
                .padding(padding)

            Image(systemName: "doc.on.clipboard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(settings.upload.placeholderForegroundColor)
                .frame(width: glyphWidth)
        }
    }
}

#Preview("Upload Image") {
    UploadImageView(
        upload: Upload(
            bytes: Data(),
            path: .camera,
            mimeType: "image/jpeg",
            fileName: "IMG_1234567890.jpg",
        ),
        settings: Settings(),
    )
}
#endif
