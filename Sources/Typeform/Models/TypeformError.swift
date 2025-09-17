public enum TypeformError: Error {
    case couldNotDetermineFirst
    case couldNotDetermineNext(_ position: Position)
    case multipleLogicForField
    case noActionForChoice
    case noEntryForField
    case noLogicForField

    case varCollectionMissingInvalidField
    case varCollectionMissingInvalidValue
    case responseTypeMismatch(Any.Type)
    case unexpectedOperation(Op)

    case fileUploadSelection
    case fileUploadData
    case fileUploadSecurity

    /// A requested `Locale.LanguageCode` was invalid for the `Form`.
    ///
    /// A code must match one in `Form.Settings.translation_languages`.
    case notAvailableInLanguage
}
