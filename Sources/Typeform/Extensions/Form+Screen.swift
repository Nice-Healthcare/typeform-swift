public extension Form {
    /// The first `Screen` that is presented for a specific `Form`.
    ///
    /// In a properly formatted `Form` this will likely be a `WelcomeScreen`.
    var firstScreen: (any Screen)? {
        welcomeScreens?.first
    }

    /// The `EndingScreen` identified as the **default**, or the first available if none.
    var defaultOrFirstEndingScreen: EndingScreen? {
        if let screen = endingScreens.first(where: { $0.ref == .default }) {
            return screen
        } else if let screen = endingScreens.first {
            return screen
        }

        return nil
    }
}
