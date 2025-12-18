import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct Form: Hashable, Sendable, Identifiable {

    public enum Kind: String, Sendable, Codable {
        case quiz
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
}

extension Form: Codable {
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

@available(macOS 13.0, macCatalyst 16.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public extension Form {
    private static let decoder: JSONDecoder = JSONDecoder()

    /// Query the Typeform api for a specific `Form`.
    ///
    /// - parameters:
    ///   - id: The unique identifier associated with the `Form`
    /// - returns: The `Form` requested
    /// - throws: `URLError`, `DecodingError`
    static func download(_ id: Form.ID) async throws -> Form {
        guard let url = URL(string: "https://api.typeform.com/forms/\(id)") else {
            throw URLError(.badURL)
        }

        let request = URLRequest(url: url)
        let response = try await URLSession.shared.data(for: request)
        return try decoder.decode(Form.self, from: response.0)
    }

    /// Retrieves a translation of the `Form` and merges string values.
    ///
    /// - parameters:
    ///   - languageCode: One of the language codes listed in the available translations.
    /// - returns: The `Form` requested with translated values.
    /// - throws: `TypeformError`, `URLError`, `DecodingError`
    func translatedTo(_ languageCode: Locale.LanguageCode) async throws -> Form {
        guard settings.languageCode != languageCode else {
            return self
        }

        guard settings.translationLanguageCodes.contains(languageCode) else {
            throw TypeformError.notAvailableInLanguage
        }

        guard let url = URL(string: "https://api.typeform.com/forms/\(id)/translation/\(languageCode.identifier)") else {
            throw URLError(.badURL)
        }

        let request = URLRequest(url: url)
        let response = try await URLSession.shared.data(for: request)
        let translation = try Self.decoder.decode(TranslatedForm.self, from: response.0)
        return merging(translatedForm: translation)
    }
}
