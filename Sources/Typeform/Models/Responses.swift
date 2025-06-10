import Foundation

public typealias Responses = [Reference: ResponseValue]

public extension Responses {
    /// The default internal implementation of `Codable` conformance on `Dictionary`
    /// will automatically fall back to alternating key/value pairs in an _un-keyed_ container
    /// when the `Key` is not a `String` or `Int`.
    var encodableDictionary: [String: ResponseValue] {
        reduce([String: ResponseValue]()) { partialResult, pair in
            var result = partialResult
            result[pair.key.rawValue] = pair.value
            return result
        }
    }
}

public extension JSONDecoder {
    func decodeResponses(from data: Data) throws -> Responses {
        let dictionary = try decode([String: ResponseValue].self, from: data)
        return dictionary.reduce([Reference: ResponseValue]()) { partialResult, pair in
            var result = partialResult
            result[Reference.make(with: pair.key)] = pair.value
            return result
        }
    }
}
