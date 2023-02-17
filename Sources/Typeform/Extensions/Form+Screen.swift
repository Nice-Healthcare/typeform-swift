public extension Form {
    /// The first `Screen` that is presented for a specific `Form`.
    ///
    /// In a properly formatted `Form` this will be a `WelcomeScreen`. When no `WelcomeScreen` is available,
    /// the `defaultOrFirstEndingScreen` will be returned.
    var firstScreen: (any Screen)? {
        if let screen = welcomeScreens.first {
            return screen
        } else if let screen = defaultOrFirstEndingScreen {
            return screen
        }
        
        return nil
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
