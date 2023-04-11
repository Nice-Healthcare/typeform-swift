import Foundation

public struct LongText: Hashable, Codable {
    public let description: String?
    
    public init(
        description: String? = nil
    ) {
        self.description = description
    }
}
