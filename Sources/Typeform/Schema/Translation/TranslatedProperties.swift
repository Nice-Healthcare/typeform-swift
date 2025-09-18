public struct TranslatedProperties: Hashable, Codable, Sendable {
    public let button_text: String?
    public let choices: [TranslatedChoice]?
    public let description: String?
    public let fields: [TranslatedField]?
    public let labels: OpinionScale.Labels?
}
