import Foundation

public struct OpinionScale: Hashable, Codable {
    
    public struct Labels: Hashable, Codable {
        
        enum CodingKeys: String, CodingKey {
            case leading = "left"
            case trailing = "right"
        }
        
        public let leading: String
        public let trailing: String
        
        public init(leading: String = "", trailing: String = "") {
            self.leading = leading
            self.trailing = trailing
        }
    }
    
    public let steps: Int
    public let labels: Labels
    public let start_at_one: Bool
    
    public init(
        steps: Int = 0,
        labels: Labels = Labels(),
        start_at_one: Bool = false
    ) {
        self.steps = steps
        self.labels = labels
        self.start_at_one = start_at_one
    }
}
