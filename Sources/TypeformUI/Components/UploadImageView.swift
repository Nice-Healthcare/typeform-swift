#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct UploadImageView: View {

    var upload: Upload
    var settings: Settings
    var removeAction: () -> Void = { }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                #if canImport(UIKit)
                if let image = UIImage(data: upload.bytes) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(
                            RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                        )
                        .padding(8)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(settings.upload.theme.selectedBackgroundColor)
                            .padding(8)

                        Image(systemName: "doc.on.clipboard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                    }
                }
                #elseif canImport(AppKit)
                if let image = NSImage(data: upload.bytes) {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(
                            RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                        )
                        .padding(8)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(settings.upload.theme.selectedBackgroundColor)
                            .padding(8)

                        Image(systemName: "doc.on.clipboard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                    }
                }
                #endif

                Button {
                    removeAction()
                } label: {
                    Label("Remove", systemImage: "x.circle.fill")
                        .labelStyle(.iconOnly)
                        .background(settings.button.theme.unselectedBackgroundColor)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: 200)

            Text(upload.fileName)
                .font(settings.typography.captionFont)
                .foregroundStyle(settings.typography.captionColor)
                .padding(.leading, 8)
        }
    }
}

#Preview("Upload Image") {
    UploadImageView(
        upload: Upload(
            bytes: Data(),
            path: .camera,
            mimeType: "image/jpeg",
            fileName: "IMG_1234567890.jpg"
        ),
        settings: Settings()
    )
}
#endif
