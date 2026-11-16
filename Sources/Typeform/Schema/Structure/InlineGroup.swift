public struct InlineGroup: FieldContainer, Hashable, Sendable, Codable {
    public let description: String?
    public let fields: [Field]
    
    public init(
        description: String? = nil,
        fields: [Field] = [],
    ) {
        self.description = description
        self.fields = fields
    }
}
