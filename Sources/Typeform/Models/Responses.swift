import Foundation

public typealias Responses = [Reference: ResponseValue]

public extension Responses {
    /// The default internal implementation of `Codable` conformance on `Dictionary`
    /// will automatically fall back to alternating key/value pairs in an _un-keyed_ container
    /// when the `Key` is not a `String` or `Int`.
    var encodableDictionary: [String: ResponseValue] {
        reduce(into: [String: ResponseValue]()) { $0[$1.key.rawValue] = $1.value }
    }
}

public extension JSONDecoder {
    /// Helper which deserializes a `Responses.encodableDictionary`.
    func decodeResponses(from data: Data) throws -> Responses {
        let dictionary = try decode([String: ResponseValue].self, from: data)
        return dictionary.reduce(into: [Reference: ResponseValue]()) { $0[Reference.make(with: $1.key)] = $1.value }
    }
}
