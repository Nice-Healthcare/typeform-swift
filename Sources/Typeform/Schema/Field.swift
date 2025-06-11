import Foundation

public struct Field: Hashable, Identifiable, Codable, Sendable {

    public enum Kind: String, Codable, Sendable {
        case date
        case dropdown
        case fileUpload = "file_upload"
        case group
        case longText = "long_text"
        case multipleChoice = "multiple_choice"
        case number
        case opinionScale = "opinion_scale"
        case rating
        case shortText = "short_text"
        case statement
        case yesNo = "yes_no"
    }

    public enum Properties: Hashable, Codable, Sendable {
        case date(DateStamp)
        case dropdown(Dropdown)
        case fileUpload(FileUpload)
        case group(Group)
        case longText(LongText)
        case multipleChoice(MultipleChoice)
        case number(Number)
        case opinionScale(OpinionScale)
        case rating(Rating)
        case shortText(ShortText)
        case statement(Statement)
        case yesNo(YesNo)

        public var description: String? {
            switch self {
            case .date(let value): value.description
            case .dropdown(let value): value.description
            case .fileUpload(let value): value.description
            case .group: nil
            case .longText(let value): value.description
            case .multipleChoice(let value): value.description
            case .number(let value): value.description
            case .opinionScale: nil
            case .rating(let value): value.description
            case .shortText(let value): value.description
            case .statement(let value): value.description
            case .yesNo(let value): value.description
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case ref
        case type
        case title
        case properties
        case validations
        case attachment
    }

    public let id: String
    public let ref: Reference
    public let type: Kind
    public let title: String
    public let properties: Properties
    public let validations: Validations?
    public let attachment: Attachment?

    public init(
        id: String = "",
        ref: Reference = "",
        type: Kind = .yesNo,
        title: String = "",
        properties: Properties = .yesNo(YesNo()),
        validations: Validations? = nil,
        attachment: Attachment? = nil
    ) {
        self.id = id
        self.ref = ref
        self.type = type
        self.title = title
        self.properties = properties
        self.validations = validations
        self.attachment = attachment
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        ref = try container.decode(Reference.self, forKey: .ref)
        type = try container.decode(Kind.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        validations = try container.decodeIfPresent(Validations.self, forKey: .validations)
        attachment = try container.decodeIfPresent(Attachment.self, forKey: .attachment)
        switch type {
        case .date:
            let date = try container.decode(DateStamp.self, forKey: .properties)
            properties = .date(date)
        case .dropdown:
            let dropdown = try container.decode(Dropdown.self, forKey: .properties)
            properties = .dropdown(dropdown)
        case .fileUpload:
            let fileUpload = try container.decode(FileUpload.self, forKey: .properties)
            properties = .fileUpload(fileUpload)
        case .group:
            let group = try container.decode(Group.self, forKey: .properties)
            properties = .group(group)
        case .longText:
            let longText = try container.decode(LongText.self, forKey: .properties)
            properties = .longText(longText)
        case .multipleChoice:
            let multipleChoice = try container.decode(MultipleChoice.self, forKey: .properties)
            properties = .multipleChoice(multipleChoice)
        case .number:
            let number = try container.decode(Number.self, forKey: .properties)
            properties = .number(number)
        case .opinionScale:
            let optionScale = try container.decode(OpinionScale.self, forKey: .properties)
            properties = .opinionScale(optionScale)
        case .rating:
            let rating = try container.decode(Rating.self, forKey: .properties)
            properties = .rating(rating)
        case .shortText:
            let shortText = try container.decode(ShortText.self, forKey: .properties)
            properties = .shortText(shortText)
        case .statement:
            let statement = try container.decode(Statement.self, forKey: .properties)
            properties = .statement(statement)
        case .yesNo:
            let yesNo = try container.decode(YesNo.self, forKey: .properties)
            properties = .yesNo(yesNo)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ref, forKey: .ref)
        try container.encode(type, forKey: .type)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(validations, forKey: .validations)
        try container.encodeIfPresent(attachment, forKey: .attachment)
        switch properties {
        case .date(let dateStamp):
            try container.encode(dateStamp, forKey: .properties)
        case .dropdown(let dropdown):
            try container.encode(dropdown, forKey: .properties)
        case .fileUpload(let fileUpload):
            try container.encode(fileUpload, forKey: .properties)
        case .group(let group):
            try container.encode(group, forKey: .properties)
        case .longText(let longText):
            try container.encode(longText, forKey: .properties)
        case .multipleChoice(let multipleChoice):
            try container.encode(multipleChoice, forKey: .properties)
        case .number(let number):
            try container.encode(number, forKey: .properties)
        case .opinionScale(let optionScale):
            try container.encode(optionScale, forKey: .properties)
        case .rating(let rating):
            try container.encode(rating, forKey: .properties)
        case .shortText(let shortText):
            try container.encode(shortText, forKey: .properties)
        case .statement(let statement):
            try container.encode(statement, forKey: .properties)
        case .yesNo(let yesNo):
            try container.encode(yesNo, forKey: .properties)
        }
    }
}

public extension Field.Kind {
    @available(*, deprecated, renamed: "fileUpload")
    static let file_upload: Self = .fileUpload
    @available(*, deprecated, renamed: "longText")
    static let long_text: Self = .longText
    @available(*, deprecated, renamed: "multipleChoice")
    static let multiple_choice: Self = .multipleChoice
    @available(*, deprecated, renamed: "opinionScale")
    static let opinion_scale: Self = .opinionScale
    @available(*, deprecated, renamed: "shortText")
    static let short_text: Self = .shortText
    @available(*, deprecated, renamed: "yesNo")
    static let yes_no: Self = .yesNo
}
