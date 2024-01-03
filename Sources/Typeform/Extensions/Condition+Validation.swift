extension Condition {
    func satisfied(given responses: Responses) -> Bool? {
        let satisfied: [Bool]
        
        switch parameters {
        case .vars(let vars):
            satisfied = vars.compactMatch(given: responses)
        case .conditions(let conditions):
            satisfied = conditions.compactMap { $0.satisfied(given: responses) }
        }
        
        switch op {
        case .always:
            return true
        case .and:
            return !satisfied.isEmpty && !satisfied.contains(false)
        case .or:
            return !satisfied.isEmpty && satisfied.contains(true)
        case .is:
            return !satisfied.isEmpty && !satisfied.contains(false)
        case .isNot:
            return !satisfied.isEmpty && !satisfied.contains(true)
        case .equal:
            print("Unexpected Condition.Op \(#function) \(#fileID) \(#line)")
            return nil
        }
    }
}
