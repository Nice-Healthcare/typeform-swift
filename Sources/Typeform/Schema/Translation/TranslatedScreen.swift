public struct TranslatedScreen: Hashable, Identifiable, Codable, Sendable {
    public let id: String
    public let title: String
    public let properties: TranslatedProperties?

    public init(
        id: String,
        title: String,
        properties: TranslatedProperties?,
    ) {
        self.id = id
        self.title = title
        self.properties = properties
    }
}

extension ScreenProperties {
    func merging(translatedProperties: TranslatedProperties?) -> ScreenProperties {
        guard let translatedProperties else {
            return self
        }

        return ScreenProperties(
            button_mode: button_mode,
            button_text: translatedProperties.button_text ?? button_text,
            share_icons: share_icons,
            show_button: show_button,
        )
    }
}

extension WelcomeScreen {
    func merging(translatedScreen: TranslatedScreen) -> WelcomeScreen {
        WelcomeScreen(
            id: id,
            ref: ref,
            title: translatedScreen.title,
            attachment: attachment,
            properties: properties.merging(translatedProperties: translatedScreen.properties),
        )
    }
}

extension [WelcomeScreen] {
    func merging(translatedScreens: [TranslatedScreen]?) -> [WelcomeScreen] {
        guard let translatedScreens else {
            return self
        }

        var screens = self
        for screen in translatedScreens {
            if let index = screens.firstIndex(where: { $0.id == screen.id }) {
                screens[index] = screens[index].merging(translatedScreen: screen)
            }
        }

        return screens
    }
}

extension EndingScreen {
    func merging(translatedScreen: TranslatedScreen) -> EndingScreen {
        EndingScreen(
            id: id,
            ref: ref,
            type: type,
            title: translatedScreen.title,
            attachment: attachment,
            properties: properties.merging(translatedProperties: translatedScreen.properties),
        )
    }
}

extension [EndingScreen] {
    func merging(translatedScreens: [TranslatedScreen]?) -> [EndingScreen] {
        guard let translatedScreens else {
            return self
        }

        var screens = self
        for screen in translatedScreens {
            if let index = screens.firstIndex(where: { $0.id == screen.id }) {
                screens[index] = screens[index].merging(translatedScreen: screen)
            }
        }

        return screens
    }
}
