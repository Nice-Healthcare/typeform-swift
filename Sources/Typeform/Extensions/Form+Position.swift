public extension Form {
    // swiftlint:disable cyclomatic_complexity
    /// Determine the next `Field` or `Screen` given the provided `Responses`.
    ///
    /// - parameters:
    ///   - position:
    ///   - responses:
    /// - returns: The next `Position`to be presented.
    /// - throws: `TypeformError`
    func next(from position: Position, given responses: Responses) throws -> Position {
        switch position {
        case .screen(let screen):
            switch screen {
            case is WelcomeScreen:
                if let field = fields.first {
                    return .field(field)
                } else if let screen = defaultOrFirstEndingScreen {
                    return .screen(screen)
                }
            default:
                break
            }
            
            throw TypeformError.couldNotDetermineNext(position)
        case .field(let field, let group):
            let entry = responses[field.ref]
            if let validations = field.validations, validations.required {
                if entry == nil {
                    throw TypeformError.noEntryForField
                }
            }
            
            // Is the `Field` of type `group`? Position at first question of sub-group.
            if case .group(let properties) = field.properties {
                guard let first = properties.fields.first else {
                    throw TypeformError.couldNotDetermineNext(position)
                }
                
                return .field(first, properties)
            }
            
            // Is there specific `Logic` for the `Field`? Process it for actions
            if let logic = logic.first(where: { $0.ref == field.ref }) {
                if let action = logic.actions.first(where: { $0.condition.satisfied(given: responses) == true }) {
                    switch action.details.to.type {
                    case .field:
                        if let position = parent(forFieldWithRef: action.details.to.value) {
                            return position
                        }
                        
                        throw TypeformError.couldNotDetermineNext(position)
                    case .ending:
                        if let next = endingScreens.first(where: { $0.ref == .ref(action.details.to.value) }) {
                            return .screen(next)
                        } else if let next = endingScreens.first(where: { $0.ref == .default }) {
                            return .screen(next)
                        }
                        
                        throw TypeformError.couldNotDetermineNext(position)
                    }
                }
            }
            
            // Are we already in a `Group`? What's the next `Field`?
            if let group = group {
                guard let index = group.fields.firstIndex(of: field) else {
                    throw TypeformError.couldNotDetermineNext(position)
                }
                
                let nextIndex = index + 1
                if nextIndex < group.fields.count {
                    return .field(group.fields[nextIndex], group)
                }
            }
            
            // If the `Group` is complete, what is the next `Field`?
            if let ancestorPosition = ancestor(forFieldWithRef: field.ref) {
                guard case .field(let ancestor, _) = ancestorPosition else {
                    throw TypeformError.couldNotDetermineNext(position)
                }
                
                guard let index = fields.firstIndex(of: ancestor) else {
                    throw TypeformError.couldNotDetermineNext(position)
                }
                
                let nextIndex = index + 1
                if nextIndex < fields.count {
                    return .field(fields[nextIndex])
                }
            }
            
            // If the `Field` has no `Logic and is not in a `Group`... what is the next `Field`?
            if let index = fields.firstIndex(of: field) {
                let nextIndex = index + 1
                if nextIndex < fields.count {
                    return .field(fields[nextIndex])
                }
            }
            
            throw TypeformError.couldNotDetermineNext(position)
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
