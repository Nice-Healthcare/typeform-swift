public struct TranslatedChoice: Hashable, Identifiable, Codable, Sendable {
    public let id: String
    public let label: String

    public init(
        id: String,
        label: String
    ) {
        self.id = id
        self.label = label
    }
}

extension Choice {
    func merging(translatedChoice: TranslatedChoice) -> Choice {
        Choice(
            id: id,
            ref: ref,
            label: translatedChoice.label
        )
    }
}

extension [Choice] {
    func merging(translatedChoices: [TranslatedChoice]?) -> [Choice] {
        guard let translatedChoices else {
            return self
        }

        var choices = self
        for choice in translatedChoices {
            if let index = choices.firstIndex(where: { $0.id == choice.id }) {
                choices[index] = choices[index].merging(translatedChoice: choice)
            }
        }

        return choices
    }
}
