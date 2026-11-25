public struct Choice: Hashable, Sendable, Codable, Identifiable {
    public let id: String
    public let ref: Reference
    public let label: String
    public let attachment: Attachment?

    public init(
        id: String = "",
        ref: Reference = "",
        label: String = "",
        attachment: Attachment? = nil,
    ) {
        self.id = id
        self.ref = ref
        self.label = label
        self.attachment = attachment
    }
}
