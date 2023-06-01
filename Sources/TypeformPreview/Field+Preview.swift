import Foundation
import Typeform

/// `MedicalIntake.json` Field References
public extension Reference {
    static let date = Reference(uuidString: "62bbe9cc-c797-4b7a-ad1d-d4328f7f8589")!
    static let dropdown = Reference(uuidString: "508ea9df-177c-4cda-8371-8f7cc1bc60a2")!
    static let group = Reference(uuidString: "778d214e-b9e1-4fca-a0ed-922369858b36")!
    static let longText = Reference(uuidString: "eeab74bc-284c-4dc7-a948-4ba045980ccf")!
    static let multipleChoice_Many = Reference(uuidString: "ab337720-ca51-402a-aa47-8ec8f316ba46")!
    static let multipleChoice_One = Reference(uuidString: "aea7a268-64d4-4f16-920a-b9afe317e3b6")!
    static let number = Reference(uuidString: "3e8760df-4a6e-47f2-8b03-0ef2e72ac35f")!
    static let rating = Reference(uuidString: "7f117917-1c53-4524-a334-fe3f60e229dd")!
    static let shortText = Reference(uuidString: "d7a86703-22e8-495b-95b2-543cd3f7dde6")!
    static let yesNo = Reference(uuidString: "5d99768b-65af-4f68-9939-87dfbd29f49a")!
    static let statement = Reference(uuidString: "8cd03d7e-412f-4be4-9e80-281f66675fca")!
}

public extension Field {
    static func field(withRef ref: Reference, in form: Form = .medicalIntake23) -> Field {
        guard let position = form.parent(forFieldWithRef: ref) else {
            preconditionFailure("Couldn't locate field with reference '\(ref)'.")
        }
        
        guard case .field(let field, _) = position else {
            preconditionFailure("Couldn't locate field with reference '\(ref)'.")
        }

        
        return field
    }
}

public extension DateStamp {
    static var preview: DateStamp = {
        guard case let .date(properties) = Field.field(withRef: .date).properties else {
            preconditionFailure("Couldn't case field to 'date'.")
        }
        
        return properties
    }()
}

public extension Dropdown {
    static var preview: Dropdown = {
        guard case let .dropdown(dropdown) = Field.field(withRef: .dropdown).properties else {
            preconditionFailure("Failed to cast field properties to type 'dropdown'.")
        }
        
        return dropdown
    }()
}

public extension Group {
    static var preview: Group = {
        guard case let .group(properties) = Field.field(withRef: .group).properties else {
            preconditionFailure("Failed to cast field properties to type 'group'.")
        }
        
        return properties
    }()
}

public extension LongText {
    static var preview: LongText = {
        guard case let .longText(properties) = Field.field(withRef: .longText).properties else {
            preconditionFailure("Couldn't case field to 'long-text'.")
        }
        
        return properties
    }()
}

public extension MultipleChoice {
    static var preview_Many: MultipleChoice = {
        guard case let .multipleChoice(properties) = Field.field(withRef: .multipleChoice_Many).properties else {
            preconditionFailure("Failed to cast field properties to type 'multiple_choice'.")
        }
        
        return properties
    }()
    
    static var preview_One: MultipleChoice = {
        guard case let .multipleChoice(properties) = Field.field(withRef: .multipleChoice_One).properties else {
            preconditionFailure("Failed to cast field properties to type 'multiple_choice'.")
        }
        
        return properties
    }()
}

public extension Number {
    static var preview: Number = {
        guard case let .number(properties) = Field.field(withRef: .number).properties else {
            preconditionFailure("Couldn't case field to 'number'.")
        }
        
        return properties
    }()
}

public extension Rating {
    static var preview: Rating = {
        guard case let .rating(properties) = Field.field(withRef: .rating).properties else {
            preconditionFailure("Couldn't case field to 'rating'.")
        }
        
        return properties
    }()
}

public extension ShortText {
    static var preview: ShortText = {
        guard case let .shortText(shortText) = Field.field(withRef: .shortText).properties else {
            preconditionFailure("Couldn't case field to 'short-text'.")
        }
        
        return shortText
    }()
}

public extension YesNo {
    static var preview: YesNo = {
        guard case let .yesNo(properties) = Field.field(withRef: .yesNo).properties else {
            preconditionFailure("Couldn't case field to 'yes-no'.")
        }
        
        return properties
    }()
}

public extension Statement {
    static var preview: Statement = {
        guard case let .statement(properties) = Field.field(withRef: .statement, in: .medicalIntake26).properties else {
            preconditionFailure("Couldn't case field to 'statement'.")
        }
        
        return properties
    }()
}
