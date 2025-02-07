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
    public let hidden: [String]?
    public let settings: Settings
    public let workspace: Workspace
    public let welcomeScreens: [WelcomeScreen]?
    public let endingScreens: [EndingScreen]

    public init(
        id: String = "",
        type: Kind = .quiz,
        logic: [Logic] = [],
        theme: Theme = Theme(),
        title: String = "",
        links: Links = Links(),
        fields: [Field] = [],
        hidden: [String]? = nil,
        settings: Settings = Settings(),
        workspace: Workspace = Workspace(),
        welcomeScreens: [WelcomeScreen]? = nil,
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
        self.welcomeScreens = welcomeScreens
        self.endingScreens = endingScreens
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(Form.Kind.self, forKey: .type)
        logic = try container.decodeIfPresent([Logic].self, forKey: .logic) ?? []
        theme = try container.decode(Theme.self, forKey: .theme)
        title = try container.decode(String.self, forKey: .title)
        links = try container.decode(Links.self, forKey: .links)
        fields = try container.decode([Field].self, forKey: .fields)
        hidden = try container.decodeIfPresent([String].self, forKey: .hidden)
        settings = try container.decode(Settings.self, forKey: .settings)
        workspace = try container.decode(Workspace.self, forKey: .workspace)
        welcomeScreens = try container.decodeIfPresent([WelcomeScreen].self, forKey: .welcomeScreens)
        endingScreens = try container.decode([EndingScreen].self, forKey: .endingScreens)
    }
}
