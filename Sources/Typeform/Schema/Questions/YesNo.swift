import Foundation

public struct YesNo: Hashable, Decodable {
    
    public let description: String?
    
    public init(description: String? = nil) {
        self.description = description
    }
}
