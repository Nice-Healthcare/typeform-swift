extension Condition {
    func satisfied(given responses: Responses) -> Bool? {
        let satisfied: [Bool]
        
        switch parameters {
        case .vars(let vars):
            satisfied = vars.compactMatch(given: responses, op: op)
        case .conditions(let conditions):
            satisfied = conditions.compactMap { $0.satisfied(given: responses) }
        }
        
        if case .always = op {
            return true
        }
        
        guard !satisfied.isEmpty else {
            return false
        }
        
        switch op {
        case .and:
            return !satisfied.contains(false)
        case .or:
            return satisfied.contains(true)
        case .is:
            return !satisfied.contains(false)
        case .isNot:
            return !satisfied.contains(true)
        default:
            print("Unexpected Condition.Op \(#function) \(#fileID) \(#line)")
            return nil
        }
    }
}
