public protocol Screen: Identifiable {
    var id: String { get }
    var title: String { get }
    var attachment: ScreenAttachment? { get }
    var properties: ScreenProperties { get }
}
