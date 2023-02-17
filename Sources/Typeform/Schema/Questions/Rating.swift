import Foundation

public struct Rating: Hashable, Decodable {
    public let shape: String
    public let steps: Int
    public let description: String?
}
