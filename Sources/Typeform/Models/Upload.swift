import Foundation

public struct Upload: Equatable {

    public enum Path: String, Identifiable {
        case camera
        case photoLibrary
        case documents

        public var id: String { rawValue }
    }

    public let bytes: Data
    public let path: Path
    public let mimeType: String

    public init(
        bytes: Data,
        path: Path,
        mimeType: String
    ) {
        self.bytes = bytes
        self.path = path
        self.mimeType = mimeType
    }
}
