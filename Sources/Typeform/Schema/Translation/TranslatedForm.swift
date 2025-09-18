import Foundation

public struct TranslatedForm: Hashable, Sendable {
    public let fields: [TranslatedField]
    public let welcomeScreens: [TranslatedScreen]?
    public let endingScreens: [TranslatedScreen]?

    public init(
        fields: [TranslatedField],
        welcomeScreens: [TranslatedScreen]?,
        endingScreens: [TranslatedScreen]?
    ) {
        self.fields = fields
        self.welcomeScreens = welcomeScreens
        self.endingScreens = endingScreens
    }
}

extension TranslatedForm: Codable {
    enum CodingKeys: String, CodingKey {
        case fields
        case welcomeScreens = "welcome_screens"
        case endingScreens = "thankyou_screens"
    }
}

public extension Form {
    func merging(translatedForm: TranslatedForm) -> Form {
        Form(
            id: id,
            type: type,
            logic: logic,
            theme: theme,
            title: title,
            fields: fields.merging(translatedFields: translatedForm.fields),
            hidden: hidden,
            settings: settings,
            workspace: workspace,
            welcomeScreens: welcomeScreens?.merging(translatedScreens: translatedForm.welcomeScreens),
            endingScreens: endingScreens.merging(translatedScreens: translatedForm.endingScreens),
        )
    }
}
