import Foundation

public struct DateStamp: Hashable, Decodable {
    public let separator: String
    public let structure: String
    public let description: String?
}
