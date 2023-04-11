import Foundation

public struct Form: Hashable, Identifiable, Codable {
    
    public enum Kind: String, Codable {
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
    
    public init(
        id: String = "",
        type: Kind = .quiz,
        logic: [Logic] = [],
        theme: Theme = Theme(),
        title: String = "",
        links: Links = Links(),
        fields: [Field] = [],
        hidden: [String] = [],
        settings: Settings = Settings(),
        workspace: Workspace = Workspace(),
        createdAt: Date = Date(),
        publishedAt: Date = Date(),
        lastUpdatedAt: Date = Date(),
        welcomeScreens: [WelcomeScreen] = [],
        endingScreens: [EndingScreen] = []
    ) {
        self.id = id
        self.type = type
        self.logic = logic
        self.theme = theme
        self.title = title
        self.links = links
        self.fields = fields
        self.hidden = hidden
        self.settings = settings
        self.workspace = workspace
        self.createdAt = createdAt
        self.publishedAt = publishedAt
        self.lastUpdatedAt = lastUpdatedAt
        self.welcomeScreens = welcomeScreens
        self.endingScreens = endingScreens
    }
}
