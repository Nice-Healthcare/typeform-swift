import Foundation

public struct Upload: Hashable {

    public enum Path: String, Hashable, Identifiable {
        case camera
        case photoLibrary
        case documents

        public var id: String { rawValue }
    }

    public let bytes: Data
    public let path: Path
    public let mimeType: String
    public let fileName: String

    public init(
        bytes: Data,
        path: Path,
        mimeType: String,
        fileName: String
    ) {
        self.bytes = bytes
        self.path = path
        self.mimeType = mimeType
        self.fileName = fileName
    }
}
