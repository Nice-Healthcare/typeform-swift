public protocol Screen: Identifiable {
    var id: String { get }
    var title: String { get }
    var attachment: Attachment? { get }
    var properties: ScreenProperties { get }
}
