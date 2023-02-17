import Foundation

public struct Form: Hashable, Identifiable, Decodable {
    
    public enum Kind: String, Decodable {
        case quiz
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case logic
        case theme
        case title
        case links = "_links"
        case fields
        case hidden
        case settings
        case workspace
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case lastUpdatedAt = "last_updated_at"
        case welcomeScreens = "welcome_screens"
        case endingScreens = "thankyou_screens"
    }
    
    public let id: String
    public let type: Kind
    public let logic: [Logic]
    public let theme: Theme
    public let title: String
    public let links: Links
    public let fields: [Field]
    public let hidden: [String]
    public let settings: Settings
    public let workspace: Workspace
    public let createdAt: Date
    public let publishedAt: Date
    public let lastUpdatedAt: Date
    public let welcomeScreens: [WelcomeScreen]
    public let endingScreens: [EndingScreen]
}
