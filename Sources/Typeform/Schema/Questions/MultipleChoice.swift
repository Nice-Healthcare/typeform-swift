import Foundation

public struct MultipleChoice: Hashable, Decodable {
    public let choices: [Choice]
    public let randomize: Bool
    public let allow_multiple_selection: Bool
    public let allow_other_choice: Bool
    public let vertical_alignment: Bool
    public let description: String?
}
