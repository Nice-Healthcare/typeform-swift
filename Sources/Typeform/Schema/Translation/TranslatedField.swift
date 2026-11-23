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
        case .checkbox(let checkbox):
            return .checkbox(
                Checkbox(
                    description: translatedProperties.description ?? checkbox.description,
                    choices: checkbox.choices.merging(translatedChoices: translatedProperties.choices),
                ),
            )
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
                    alphabetical: dropdown.alphabetical,
                ),
            )
        case .email:
            return self
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
        case .inlineGroup(let inlineGroup):
            return .inlineGroup(
                InlineGroup(
                    description: translatedProperties.description,
                    fields: inlineGroup.fields.merging(translatedFields: translatedProperties.fields),
                ),
            )
        case .legal(let legal):
            return .legal(
                Legal(
                    description: translatedProperties.description ?? legal.description,
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
                    description: translatedProperties.description ?? multipleChoice.description,
                    randomize: multipleChoice.randomize,
                    allowMultipleSelection: multipleChoice.allowMultipleSelection,
                    allowOtherChoice: multipleChoice.allowOtherChoice,
                    allowNoneOfTheAbove: multipleChoice.allowNoneOfTheAbove,
                    verticalAlignment: multipleChoice.verticalAlignment,
                ),
            )
        case .netPromoterScore(let netPromoterScore):
            return .netPromoterScore(
                NetPromoterScore(
                    description: translatedProperties.description ?? netPromoterScore.description,
                    steps: netPromoterScore.steps,
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
                    startAtOne: opinionScale.startAtOne,
                    labels: translatedProperties.labels ?? opinionScale.labels,
                ),
            )
        case .pictureChoice(let pictureChoice):
            return .pictureChoice(
                PictureChoice(
                    choices: pictureChoice.choices.merging(translatedChoices: translatedProperties.choices),
                    description: translatedProperties.description ?? pictureChoice.description,
                    randomize: pictureChoice.randomize,
                    allowMultipleSelection: pictureChoice.allowMultipleSelection,
                    allowOtherChoice: pictureChoice.allowOtherChoice,
                    allowNoneOfTheAbove: pictureChoice.allowNoneOfTheAbove,
                    supersized: pictureChoice.supersized,
                    showLabels: pictureChoice.showLabels,
                ),
            )
        case .phoneNumber:
            return self
        case .ranking(let ranking):
            return .ranking(
                Ranking(
                    choices: ranking.choices.merging(translatedChoices: translatedProperties.choices),
                    description: translatedProperties.description ?? ranking.description,
                    randomize: ranking.randomize,
                    allowMultipleSelection: ranking.allowMultipleSelection,
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
        case .website(let website):
            return .website(
                Website(
                    description: translatedProperties.description ?? website.description,
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
