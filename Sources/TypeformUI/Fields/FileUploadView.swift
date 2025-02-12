#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct FileUploadView: View {

    var state: Binding<ResponseState>
    var properties: FileUpload
    var settings: Settings
    var validations: Validations?

    @State private var value: Upload?
    @State private var path: Upload.Path?
    @State private var error: Error?

    private var image: UIImage? {
        guard let value else {
            return nil
        }

        guard value.mimeType.hasPrefix("image") else {
            return nil
        }

        return UIImage(data: value.bytes)
    }

    var body: some View {
        VStack(spacing: settings.presentation.contentVerticalSpacing) {
            if value != nil {
                ZStack(alignment: .topTrailing) {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(
                                RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                            )
                            .padding(8)
                    } else {
                        Image(systemName: "doc")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(
                                RoundedRectangle(cornerRadius: settings.upload.imageRadius)
                            )
                            .padding(8)
                    }

                    Button {
                        value = nil
                    } label: {
                        Label("Remove", systemImage: "x.circle.fill")
                            .labelStyle(.iconOnly)
                            .background(settings.button.theme.unselectedBackgroundColor)
                            .clipShape(Circle())
                    }
                }
            } else {
                Menu {
                    Button {
                        path = .camera
                    } label: {
                        Label(settings.localization.uploadCamera, systemImage: "camera")
                    }
                    Button {
                        path = .photoLibrary
                    } label: {
                        Label(settings.localization.uploadPhotoLibrary, systemImage: "photo")
                    }
                    Button {
                        path = .documents
                    } label: {
                        Label(settings.localization.uploadDocument, systemImage: "folder")
                    }
                } label: {
                    Label(settings.localization.uploadAction, systemImage: "plus")
                        .labelStyle(UploadLabelStyle(settings: settings))
                }
            }

            if let error {
                Text(error.localizedDescription)
            }
        }
        .sheet(item: $path) { uploadPath in
            UploadPickerView(path: uploadPath) { result in
                handlePickerResult(result)
            }
        }
        .onAppear {
            registerState()
        }
        .onChange(of: value) { _ in
            updateState()
        }
    }

    private func registerState() {
        switch state.wrappedValue.response {
        case .upload(let upload):
            value = upload
        default:
            value = nil
        }

        updateState()
    }

    private func updateState() {
        var state = state.wrappedValue

        if let response = value {
            state.response = .upload(response)
        } else {
            state.response = nil
        }

        if let validations, validations.required {
            state.invalid = value == nil
        } else {
            state.invalid = false
        }

        self.state.wrappedValue = state
    }

    private func handlePickerResult(_ result: Result<Upload, Error>?) {
        path = nil

        switch result {
        case .success(let upload):
            value = upload
            error = nil
        case .failure(let failure):
            value = nil
            error = failure
        case nil:
            value = nil
            error = nil
        }
    }
}

#Preview("File Upload View") {
    FileUploadView(
        state: .constant(ResponseState()),
        properties: FileUpload(description: nil),
        settings: Settings()
    )
}
#endif
