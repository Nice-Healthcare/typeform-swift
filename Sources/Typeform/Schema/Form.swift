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
    @available(*, deprecated, message: "This is no longer in the API contract.")
    public let createdAt: Date
    @available(*, deprecated, message: "This is no longer in the API contract.")
    public let publishedAt: Date
    @available(*, deprecated, message: "This is no longer in the API contract.")
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(Form.Kind.self, forKey: .type)
        self.logic = try container.decode([Logic].self, forKey: .logic)
        self.theme = try container.decode(Theme.self, forKey: .theme)
        self.title = try container.decode(String.self, forKey: .title)
        self.links = try container.decode(Links.self, forKey: .links)
        self.fields = try container.decode([Field].self, forKey: .fields)
        self.hidden = try container.decode([String].self, forKey: .hidden)
        self.settings = try container.decode(Settings.self, forKey: .settings)
        self.workspace = try container.decode(Workspace.self, forKey: .workspace)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        self.publishedAt = try container.decodeIfPresent(Date.self, forKey: .publishedAt) ?? Date()
        self.lastUpdatedAt = try container.decodeIfPresent(Date.self, forKey: .lastUpdatedAt) ?? Date()
        self.welcomeScreens = try container.decode([WelcomeScreen].self, forKey: .welcomeScreens)
        self.endingScreens = try container.decode([EndingScreen].self, forKey: .endingScreens)
    }
}
