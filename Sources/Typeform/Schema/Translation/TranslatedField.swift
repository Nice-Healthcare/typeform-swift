public struct TranslatedField: Hashable, Identifiable, Codable, Sendable {
    public let id: String
    public let title: String?
    public let properties: TranslatedProperties?

    public init(
        id: String,
        title: String?,
        properties: TranslatedProperties?,
    ) {
        self.id = id
        self.title = title
        self.properties = properties
    }
}

extension Field {
    func merging(translatedField: TranslatedField) -> Field {
        Field(
            id: id,
            ref: ref,
            type: type,
            title: translatedField.title ?? title,
            properties: properties.merging(translatedProperties: translatedField.properties),
            validations: validations,
            attachment: attachment,
        )
    }
}

extension Field.Properties {
    func merging(translatedProperties: TranslatedProperties?) -> Field.Properties {
        guard let translatedProperties else {
            return self
        }

        switch self {
        case .date(let dateStamp):
            return .date(
                DateStamp(
                    separator: dateStamp.separator,
                    structure: dateStamp.structure,
                    description: translatedProperties.description ?? dateStamp.description,
                ),
            )
        case .dropdown(let dropdown):
            return .dropdown(
                Dropdown(
                    choices: dropdown.choices.merging(translatedChoices: translatedProperties.choices),
                    description: translatedProperties.description ?? dropdown.description,
                    randomize: dropdown.randomize,
                    alphabetical_order: dropdown.alphabetical_order,
                ),
            )
        case .fileUpload(let fileUpload):
            return .fileUpload(
                FileUpload(
                    description: translatedProperties.description ?? fileUpload.description,
                ),
            )
        case .group(let group):
            return .group(
                Group(
                    button_text: translatedProperties.button_text ?? group.button_text,
                    fields: group.fields.merging(translatedFields: translatedProperties.fields),
                    show_button: group.show_button,
                ),
            )
        case .longText(let longText):
            return .longText(
                LongText(
                    description: translatedProperties.description ?? longText.description,
                ),
            )
        case .matrix(let matrix):
            return .matrix(
                Matrix(
                    fields: matrix.fields.merging(translatedFields: translatedProperties.fields),
                ),
            )
        case .multipleChoice(let multipleChoice):
            return .multipleChoice(
                MultipleChoice(
                    choices: multipleChoice.choices.merging(translatedChoices: translatedProperties.choices),
                    randomize: multipleChoice.randomize,
                    allow_multiple_selection: multipleChoice.allow_multiple_selection,
                    allow_other_choice: multipleChoice.allow_other_choice,
                    vertical_alignment: multipleChoice.vertical_alignment,
                    description: translatedProperties.description ?? multipleChoice.description,
                ),
            )
        case .number(let number):
            return .number(
                Number(
                    description: translatedProperties.description ?? number.description,
                ),
            )
        case .opinionScale(let opinionScale):
            return .opinionScale(
                OpinionScale(
                    steps: opinionScale.steps,
                    labels: translatedProperties.labels ?? opinionScale.labels,
                    start_at_one: opinionScale.start_at_one,
                ),
            )
        case .rating(let rating):
            return .rating(
                Rating(
                    shape: rating.shape,
                    steps: rating.steps,
                    description: translatedProperties.description ?? rating.description,
                ),
            )
        case .shortText(let shortText):
            return .shortText(
                ShortText(
                    description: translatedProperties.description ?? shortText.description,
                ),
            )
        case .statement(let statement):
            return .statement(
                Statement(
                    hide_marks: statement.hide_marks,
                    button_text: translatedProperties.button_text ?? statement.button_text,
                    description: translatedProperties.description ?? statement.description,
                ),
            )
        case .yesNo(let yesNo):
            return .yesNo(
                YesNo(
                    description: translatedProperties.description ?? yesNo.description,
                ),
            )
        }
    }
}

extension [Field] {
    func merging(translatedFields: [TranslatedField]?) -> [Field] {
        guard let translatedFields else {
            return self
        }

        var fields = self
        for field in translatedFields {
            if let index = fields.firstIndex(where: { $0.id == field.id }) {
                fields[index] = fields[index].merging(translatedField: field)
            }
        }

        return fields
    }
}
