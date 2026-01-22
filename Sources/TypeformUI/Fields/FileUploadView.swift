#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview
import UniformTypeIdentifiers

struct FileUploadView: View {

    var state: Binding<ResponseState>
    var properties: FileUpload
    var settings: Settings
    var validations: Validations?

    @State private var value: Upload?
    @State private var path: Upload.Path?
    @State private var error: (any Error)?

    var body: some View {
        VStack(spacing: settings.presentation.contentVerticalSpacing) {
            if let value {
                UploadImageView(
                    upload: value,
                    settings: settings
                ) {
                    self.value = nil
                }
            } else {
                #if canImport(UIKit)
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
                .buttonStyle(.plain)
                #elseif canImport(AppKit)
                Button {
                    selectFile()
                } label: {
                    Label(settings.localization.uploadAction, systemImage: "plus")
                        .labelStyle(UploadLabelStyle(settings: settings))
                }
                .buttonStyle(.plain)
                #else
                Text("Unsupported Platform")
                #endif
            }

            if let error {
                Text(error.localizedDescription)
            }
        }
        #if canImport(UIKit)
        .sheet(item: $path) { uploadPath in
            UploadPickerView(path: uploadPath) { result in
                handlePickerResult(result)
            }
        }
        #endif
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

    private func handlePickerResult(_ result: Result<Upload, any Error>?) {
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

    #if canImport(AppKit)
    private func selectFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [
            .pdf,
            .jpeg,
            .png,
            .heic,
            .heif,
        ]

        guard case .OK = panel.runModal() else {
            return
        }

        guard let url = panel.url else {
            return
        }

        guard let bytes = try? Data(contentsOf: url) else {
            handlePickerResult(.failure(TypeformError.fileUploadData))
            return
        }

        guard let resourceValues = try? url.resourceValues(forKeys: [.contentTypeKey, .nameKey]) else {
            handlePickerResult(.failure(TypeformError.fileUploadData))
            return
        }

        let uniformType = resourceValues.contentType ?? .fileURL
        let mimeType = uniformType.preferredMIMEType ?? "application/octet-stream"
        let fileName = resourceValues.name ?? "New Document\(uniformType.preferredFilenameExtension ?? "")"

        let upload = Upload(
            bytes: bytes,
            path: .documents,
            mimeType: mimeType,
            fileName: fileName
        )

        handlePickerResult(.success(upload))
    }
    #endif
}

#Preview("File Upload View") {
    FileUploadView(
        state: .constant(ResponseState()),
        properties: FileUpload(description: nil),
        settings: Settings()
    )
}
#endif
