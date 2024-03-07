public extension Form {
    /// Determine the first `Position` that should be displayed given the provided `Responses`.
    ///
    /// When preloading responses for the form, the _first_ field may no longer be the one desired to be shown.
    ///
    /// - parameters:
    ///   - skipWelcomeScreen: Flag indicated whether a 'Welcome Screen' should be skipped if present.
    ///   - responses: Any responses that are already known when the form is first presented.
    /// - returns: The first `Position` to be presented.
    func firstPosition(skipWelcomeScreen: Bool, given responses: Responses) throws -> Position {
        if let screen = firstScreen, !skipWelcomeScreen {
            return .screen(screen)
        }
        
        guard let field = fields.first else {
            if let screen = defaultOrFirstEndingScreen {
                return .screen(screen)
            } else {
                throw TypeformError.couldNotDetermineFirst
            }
        }
        
        if field.type == .statement {
            return .field(field, nil)
        }
        
        return try next(from: .field(field), given: responses)
    }
     
    /// Determine the next `Field` or `Screen` given the provided `Responses`.
    ///
    /// - parameters:
    ///   - position: The current `Position` from which to determine the next field or screen to present.
    ///   - responses: The current `Responses` gathered while interacting with the form.
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
            var next: Position = .field(field, group)
            do {
                next = try nextPosition(from: field, group: group, given: responses)
                var requiresResponse = false
                
                while !requiresResponse {
                    switch next {
                    case .screen:
                        requiresResponse = true
                    case .field(let nextField, let nextGroup):
                        if responses[nextField.ref] == nil {
                            requiresResponse = true
                        } else {
                            next = try nextPosition(from: nextField, group: nextGroup, given: responses)
                        }
                    }
                }
                
                return next
            } catch TypeformError.noEntryForField {
                return next
            }
        }
    }
}

private extension Form {
    // swiftlint:disable cyclomatic_complexity
    func nextPosition(from field: Field, group: Group?, given responses: Responses) throws -> Position {
        let currentPosition: Position = .field(field, group)
        
        // Is a response required of the current position?
        if responses.responseRequired(for: field) {
            throw TypeformError.noEntryForField
        }
        
        // Is this `Field` of type `group`?
        if case .group(let properties) = field.properties {
            guard let firstGroupField = properties.fields.first else {
                throw TypeformError.couldNotDetermineNext(currentPosition)
            }
            
            return .field(firstGroupField, properties)
        }
        
        // Is there `Logic` that applies to this `Field`?
        if let logic = logic.first(where: { $0.ref == field.ref }) {
            if let action = logic.actions.first(where: { $0.condition.satisfied(given: responses) == true }) {
                switch action.details.to.type {
                case .field:
                    if let position = parent(forFieldWithRef: action.details.to.value) {
                        return position
                    }
                    
                    throw TypeformError.couldNotDetermineNext(currentPosition)
                case .ending:
                    if let screen = endingScreens.first(where: { $0.ref == .ref(action.details.to.value) }) {
                        return .screen(screen)
                    } else if let screen = endingScreens.first(where: { $0.ref == .default }) {
                        return .screen(screen)
                    }
                    
                    throw TypeformError.couldNotDetermineNext(currentPosition)
                }
            }
        }
        
        // Are we already in a `Group`?
        if let group = group {
            // Is there a next `Field`
            guard let fieldIndex = group.fields.firstIndex(of: field) else {
                throw TypeformError.couldNotDetermineNext(currentPosition)
            }
            
            if (fieldIndex + 1) < group.fields.count {
                return .field(group.fields[fieldIndex + 1], group)
            }
            
            // Is the `Group` complete?
            if let ancestorPosition = ancestor(forFieldWithRef: field.ref) {
                guard case .field(let ancestor, _) = ancestorPosition else {
                    throw TypeformError.couldNotDetermineNext(currentPosition)
                }
                
                guard let ancestorIndex = fields.firstIndex(of: ancestor) else {
                    throw TypeformError.couldNotDetermineNext(currentPosition)
                }
                
                if (ancestorIndex + 1) < fields.count {
                    return .field(fields[ancestorIndex + 1])
                }
            }
        }
        
        // Is there a next `Field`?
        if let index = fields.firstIndex(of: field) {
            switch index + 1 {
            case let x where x == fields.count:
                if let screen = defaultOrFirstEndingScreen {
                    return .screen(screen)
                }
            case let x where x < fields.count:
                return .field(fields[x])
            default:
                break
            }
        }
        
        throw TypeformError.couldNotDetermineNext(currentPosition)
    }
    // swiftlint:enable cyclomatic_complexity
}

private extension Responses {
    func responseRequired(for field: Field) -> Bool {
        guard let validations = field.validations else {
            return false
        }
        
        guard validations.required else {
            return false
        }
        
        guard self[field.ref] == nil else {
            return false
        }
        
        return true
    }
}
