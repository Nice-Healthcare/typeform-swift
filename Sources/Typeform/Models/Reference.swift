#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public enum Reference: Hashable, Sendable {
    case string(String)
    case uuid(UUID)

    /// Controls the behavior of `Reference` encoding.
    ///
    /// By default, `JSONEncoder` will encode the underlying `UUID` in all uppercase characters.
    /// Since the **Typeform** api uses lowercased GUID for reference strings, the default encoding behavior is to match.
    @available(*, deprecated)
    public enum ValueEncodingCase {
        /// The system default behavior is used.
        case automatic
        /// The value will be encoded using only upper-case characters.
        case uppercase
        /// The value will be encoded using only lower-case characters.
        case lowercase
    }

    @available(*, deprecated, message: "UUIDs will be encoded in lowercase to match the Typeform API expectations.")
    public static var valueEncodingCase: ValueEncodingCase = .lowercase

    public static func make(with value: String) -> Reference {
        if let uuid = UUID(uuidString: value) {
            return .uuid(uuid)
        }

        return .string(value)
    }

    public var uuidString: String? {
        guard case .uuid(let uuid) = self else {
            return nil
        }

        return uuid.uuidString
    }

    public init(string: String = "") {
        self = .string(string)
    }

    public init?(uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            return nil
        }

        self = .uuid(uuid)
    }
}

extension Reference: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            let uuid = try container.decode(UUID.self)
            self = .uuid(uuid)
            return
        } catch {}

        let rawValue = try container.decode(String.self)
        self = .string(rawValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .string(let string):
            try container.encode(string)
        case .uuid(let uuid):
            try container.encode(uuid.uuidString.lowercased())
        }
    }
}

extension Reference: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = Self.make(with: value)
    }
}

extension Reference: RawRepresentable {
    public init?(rawValue: String) {
        self = Self.make(with: rawValue)
    }

    public var rawValue: String {
        get {
            switch self {
            case .string(let string): string
            case .uuid(let uuid):
                uuid.uuidString.lowercased()
            }
        }
        set {
            self = Self.make(with: newValue)
        }
    }
}
