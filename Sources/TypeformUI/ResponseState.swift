import Typeform

/// A collective representation of a single `Responses` element.
struct ResponseState: Equatable {
    /// The `ResponseValue` for the given `Field` being presented.
    var response: ResponseValue?
    /// Indication of whether validation indicates a failure.
    var invalid: Bool
    
    init(response: ResponseValue? = nil, invalid: Bool = true) {
        self.response = response
        self.invalid = invalid
    }
    
    init(for field: Field, given responses: Responses) {
        self.response = responses[field.ref]
        if case .statement = field.properties {
            self.invalid = false
        } else {
            self.invalid = true
        }
    }
}
