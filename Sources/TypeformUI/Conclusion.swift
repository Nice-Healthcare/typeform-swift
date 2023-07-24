import Typeform

/// The outcome of answering a specific `Form`
public enum Conclusion {
    /// The `Form` was completed to a defined endpoint.
    case completed(Responses, EndingScreen)
    /// The `Form` was abandoned after the `WelcomeScreen` and before a `EndingScreen`.
    case abandoned(Responses)
    /// The `Form` was rejected due to invalid form logic & navigation.
    case rejected(Responses)
    /// The `Form` was cancelled without moving past a `WelcomeScreen`.
    case canceled
}
