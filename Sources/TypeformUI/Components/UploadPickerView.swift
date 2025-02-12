#if canImport(SwiftUI) && canImport(UIKit)
import PhotosUI
import SwiftUI
import Typeform
import UniformTypeIdentifiers

struct UploadPickerView: UIViewControllerRepresentable {

    var path: Upload.Path
    var resultHandler: (Result<Upload, Error>?) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        switch path {
        case .camera:
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.delegate = context.coordinator
            controller.allowsEditing = true
            return controller
        case .photoLibrary:
            var config = PHPickerConfiguration()
            config.filter = .any(of: [.images, .screenshots])

            let controller = PHPickerViewController(configuration: config)
            controller.delegate = context.coordinator
            return controller
        case .documents:
            let contentTypes: [UTType] = [
                .jpeg,
                .png,
                .pdf
            ]
            
            let controller = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
            controller.delegate = context.coordinator
            return controller
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> UploadPickerCoordinator {
        UploadPickerCoordinator(path: path, resultHandler: resultHandler)
    }
}

class UploadPickerCoordinator: NSObject, UINavigationControllerDelegate {

    let path: Upload.Path
    let resultHandler: (Result<Upload, Error>?) -> Void

    init(
        path: Upload.Path,
        resultHandler: @escaping (Result<Upload, Error>?) -> Void
    ) {
        self.path = path
        self.resultHandler = resultHandler
    }
}

extension UploadPickerCoordinator: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image: UIImage? = if let image = info[.editedImage] as? UIImage {
            image
        } else if let image = info[.originalImage] as? UIImage {
            image
        } else {
            nil
        }

        guard let image else {
            resultHandler(.failure(TypeformError.fileUploadSelection))
            return
        }

        guard let bytes = image.jpegData(compressionQuality: 0.9) else {
            resultHandler(.failure(TypeformError.fileUploadData))
            return
        }

        let upload = Upload(
            bytes: bytes,
            path: .camera,
            mimeType: UTType.jpeg.preferredMIMEType ?? "image/jpeg"
        )

        resultHandler(.success(upload))
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        resultHandler(nil)
    }
}

extension UploadPickerCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let provider = results.first?.itemProvider else {
            resultHandler(nil)
            return
        }

        guard provider.canLoadObject(ofClass: UIImage.self) else {
            resultHandler(.failure(TypeformError.fileUploadSelection))
            return
        }

        Task {
            let result: Result<Upload, Error>
            do {
                let image = try await image(from: provider)
                guard let bytes = image.jpegData(compressionQuality: 0.9) else {
                    throw TypeformError.fileUploadData
                }

                let upload = Upload(
                    bytes: bytes,
                    path: .photoLibrary,
                    mimeType: UTType.jpeg.preferredMIMEType ?? "image/jpeg"
                )
                result = .success(upload)
            } catch {
                result = .failure(error)
            }

            await MainActor.run {
                resultHandler(result)
            }
        }
    }

    private func image(from provider: NSItemProvider) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadObject(ofClass: UIImage.self) { reading, error in
                switch (reading, error) {
                case (.some(let image as UIImage), _):
                    continuation.resume(returning: image)
                case (_, .some(let throwing)):
                    continuation.resume(throwing: throwing)
                default:
                    continuation.resume(throwing: CocoaError(.fileReadCorruptFile))
                }
            }
        }
    }
}

// `UIDocumentPickerViewController` is automatically dismissed
extension UploadPickerCoordinator: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            resultHandler(.failure(TypeformError.fileUploadSelection))
            return
        }

        do {
            guard url.startAccessingSecurityScopedResource() else {
                throw TypeformError.fileUploadSecurity
            }

            defer {
                url.stopAccessingSecurityScopedResource()
            }

            guard let bytes = try? Data(contentsOf: url) else {
                throw TypeformError.fileUploadData
            }

            guard let resourceValues = try? url.resourceValues(forKeys: [.contentTypeKey]) else {
                throw TypeformError.fileUploadData
            }

            let uniformType = resourceValues.contentType ?? .fileURL
            let mimeType = uniformType.preferredMIMEType ?? "application/octet-stream"

            let upload = Upload(
                bytes: bytes,
                path: .documents,
                mimeType: mimeType
            )

            resultHandler(.success(upload))
        } catch {
            resultHandler(.failure(error))
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        resultHandler(nil)
    }
}
#endif
