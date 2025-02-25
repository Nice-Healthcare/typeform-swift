extension Collection<Var> {
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
                return choices.map(\.ref).contains(reference)
            default:
                return false
            }
        case .string(let string):
            if case .string(let stringValue) = response {
                return try? op.compareString(response: stringValue, to: string)
            } else if case .date(let dateValue) = response {
                return try? op.compareDate(response: dateValue, to: string)
            } else {
                print(TypeformError.responseTypeMismatch(String.self))
                return nil
            }
        case .int(let int):
            guard case .int(let responseValue) = response else {
                print(TypeformError.responseTypeMismatch(Int.self))
                return nil
            }

            return try? op.compareInt(response: responseValue, to: int)
        }
    }

    func compactMatch(given responses: Responses, op: Op) -> [Bool] {
        if let match = match(given: responses, op: op) {
            [match]
        } else {
            []
        }
    }
}
