extension Collection where Element == Var {
    func match(given responses: Responses, op: Op) -> Bool? {
        guard !isEmpty else {
            return true
        }
        
        guard let fieldVar = first(where: { $0.type == .field })?.value else {
            return nil
        }
        
        guard case let .ref(fieldRef) = fieldVar else {
            return nil
        }
        
        guard let valueVar = first(where: { $0.type != .field })?.value else {
            return nil
        }
        
        guard let response = responses.first(where: { $0.key == fieldRef })?.value else {
            return nil
        }
        
        switch valueVar {
        case .bool(let bool):
            guard case .bool(let responseValue) = response else {
                print(TypeformError.responseTypeMismatch(Bool.self))
                return nil
            }
            
            return responseValue == bool
        case .ref(let reference):
            switch response {
            case .choice(let choice):
                return choice.ref == reference
            case .choices(let choices):
                return choices.map { $0.ref }.contains(reference)
            default:
                return false
            }
        case .string(let string):
            guard case .string(let responseValue) = response else {
                print(TypeformError.responseTypeMismatch(String.self))
                return nil
            }
            
            return responseValue == string
        case .int(let int):
            guard case .int(let responseValue) = response else {
                print(TypeformError.responseTypeMismatch(Int.self))
                return nil
            }
            
            switch op {
            case .equal:
                return responseValue == int
            case .greaterEqualThan:
                return responseValue >= int
            case .lowerEqualThan:
                return responseValue <= int
            default:
                print(TypeformError.unexpectedOperation(op))
                return nil
            }
        }
    }
    
    func compactMatch(given responses: Responses, op: Op) -> [Bool] {
        if let match = match(given: responses, op: op) {
            return [match]
        } else {
            return []
        }
    }
}
