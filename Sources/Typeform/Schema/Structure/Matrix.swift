public struct Matrix: FieldContainer, Hashable, Sendable, Codable {

    public struct Iteration: Identifiable {
        public let id: Field.ID
        public let ref: Reference
        public let title: String
        public let question: MultipleChoice
    }

    public let fields: [Field]

    public init(
        fields: [Field] = []
    ) {
        self.fields = fields
    }

    public var questions: [Iteration] {
        fields.reduce(into: [Iteration]()) { partialResult, field in
            guard case .multipleChoice(let multipleChoice) = field.properties else {
                return
            }

            partialResult.append(
                Iteration(
                    id: field.id,
                    ref: field.ref,
                    title: field.title,
                    question: multipleChoice
                )
            )
        }
    }

    public var columns: [String] {
        guard case .multipleChoice(let multipleChoice) = fields.first?.properties else {
            return []
        }

        return multipleChoice.choices.map(\.label)
    }

    public var rows: [String] {
        questions.map(\.title)
    }

    public var allow_multiple_selections: Bool {
        guard case .multipleChoice(let multipleChoice) = fields.first?.properties else {
            return false
        }

        return multipleChoice.allow_multiple_selection
    }

    public var validations: Validations? {
        fields.first?.validations
    }
}
