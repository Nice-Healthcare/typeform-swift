public enum TypeformError: Error {
    case couldNotDetermineFirst
    case couldNotDetermineNext(_ position: Position)
    case multipleLogicForField
    case noActionForChoice
    case noEntryForField
    case noLogicForField
    case endOfForm
    
    case varCollectionMissingInvalidField
    case varCollectionMissingInvalidValue
    case responseTypeMismatch(Any.Type)
}
