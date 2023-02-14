import Foundation

public struct Field: Hashable, Identifiable, Decodable {
    
    public enum Kind: String, Decodable {
        case date
        case dropdown
        case group
        case long_text
        case multiple_choice
        case number
        case rating
        case short_text
        case statement
        case yes_no
    }
    
    public enum Properties: Hashable, Decodable {
        case date(DateStamp)
        case dropdown(Dropdown)
        case group(Group)
        case longText(LongText)
        case multipleChoice(MultipleChoice)
        case number(Number)
        case rating(Rating)
        case shortText(ShortText)
        case statement(Statement)
        case yesNo(YesNo)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ref
        case type
        case title
        case properties
        case validations
    }
    
    public let id: String
    public let ref: Reference
    public let type: Kind
    public let title: String
    public let properties: Properties
    public let validations: Validations?
    
    internal init(
        id: String = "",
        ref: Reference = Reference(),
        type: Kind = .yes_no,
        title: String = "",
        properties: Properties = .yesNo(YesNo()),
        validations: Validations? = nil
    ) {
        self.id = id
        self.ref = ref
        self.type = type
        self.title = title
        self.properties = properties
        self.validations = validations
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        ref = try container.decode(Reference.self, forKey: .ref)
        type = try container.decode(Kind.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        validations = try container.decodeIfPresent(Validations.self, forKey: .validations)
        switch type {
        case .date:
            let date = try container.decode(DateStamp.self, forKey: .properties)
            properties = .date(date)
        case .dropdown:
            let dropdown = try container.decode(Dropdown.self, forKey: .properties)
            properties = .dropdown(dropdown)
        case .group:
            let group = try container.decode(Group.self, forKey: .properties)
            properties = .group(group)
        case .long_text:
            let longText = try container.decode(LongText.self, forKey: .properties)
            properties = .longText(longText)
        case .multiple_choice:
            let multipleChoice = try container.decode(MultipleChoice.self, forKey: .properties)
            properties = .multipleChoice(multipleChoice)
        case .number:
            let number = try container.decode(Number.self, forKey: .properties)
            properties = .number(number)
        case .rating:
            let rating = try container.decode(Rating.self, forKey: .properties)
            properties = .rating(rating)
        case .short_text:
            let shortText = try container.decode(ShortText.self, forKey: .properties)
            properties = .shortText(shortText)
        case .statement:
            let statement = try container.decode(Statement.self, forKey: .properties)
            properties = .statement(statement)
        case .yes_no:
            let yesNo = try container.decode(YesNo.self, forKey: .properties)
            properties = .yesNo(yesNo)
        }
    }
}