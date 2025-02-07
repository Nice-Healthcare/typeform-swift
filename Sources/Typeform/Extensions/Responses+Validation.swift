public extension Responses {
    /// Verify that `ResponseValue`s in the collection are valid given the `Field` definitions.
    ///
    /// For instance: if a `MultipleChoice` field which only allows a single-selection has more than one `Choice`,
    /// this is an invalid state.
    ///
    /// - parameters:
    ///   - fields: The `Form.fields` used to validate the collection.
    func validResponseValues(given fields: [Field]) -> Bool {
        invalidResponseValues(given: fields).isEmpty
    }

    /// Collection of invalid `Reference` keys based on expected `ResponseValue` types.
    ///
    /// For instance: if a `MultipleChoice` field which only allows a single-selection has more than one `Choice`,
    /// this is an invalid state.
    ///
    /// - parameters:
    ///   - fields: The `Form.fields` used to validate the collection.
    func invalidResponseValues(given fields: [Field]) -> [Reference] {
        compactMap { key, value -> Reference? in
            guard let field = fields.field(withRef: key) else {
                return key
            }

            switch field.properties {
            case .date:
                guard case .date = value else {
                    return key
                }
            case .dropdown:
                guard case .choice = value else {
                    return key
                }
            case .group:
                return key
            case .longText:
                guard case .string = value else {
                    return key
                }
            case .multipleChoice(let multipleChoice):
                if multipleChoice.allow_multiple_selection {
                    guard case .choices = value else {
                        return key
                    }
                } else {
                    guard case .choice = value else {
                        return key
                    }
                }
            case .number:
                guard case .int = value else {
                    return key
                }
            case .opinionScale:
                guard case .int = value else {
                    return key
                }
            case .rating:
                guard case .int = value else {
                    return key
                }
            case .shortText:
                guard case .string = value else {
                    return key
                }
            case .statement:
                return key
            case .yesNo:
                guard case .bool = value else {
                    return key
                }
            }

            return nil
        }
    }
}
