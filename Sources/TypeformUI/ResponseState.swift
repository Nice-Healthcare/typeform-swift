import Typeform

struct ResponseState: Equatable {
    var response: ResponseValue?
    var passesValidation: Bool
    
    init(response: ResponseValue? = nil, passesValidation: Bool = false) {
        self.response = response
        self.passesValidation = passesValidation
    }
    
    init(field: Field, responses: Responses) {
        self.response = responses[field.ref]
        self.passesValidation = false
    }
}
