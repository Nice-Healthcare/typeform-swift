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
        response = responses[field.ref]
        if case .group = field.properties {
            invalid = false
        } else if case .statement = field.properties {
            invalid = false
        } else {
            invalid = true
        }
    }
}
