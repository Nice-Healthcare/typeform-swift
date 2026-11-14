import Foundation
import Typeform

public extension Form {
    private static let decoder: JSONDecoder = JSONDecoder()

    /// Query the Typeform api for a specific `Form`.
    ///
    /// - parameters:
    ///   - id: The unique identifier associated with the `Form`
    /// - returns: The `Form` requested
    /// - throws: `URLError`, `DecodingError`
    static func download(_ id: Form.ID) async throws -> Form {
        guard let url = URL(string: "https://api.typeform.com/forms/\(id)") else {
            throw TypeformError.parseURL
        }

        let request = URLRequest(url: url)
        let response = try await URLSession.shared.data(for: request)
        return try decoder.decode(Form.self, from: response.0)
    }

    /// Retrieves a translation of the `Form` and merges string values.
    ///
    /// - parameters:
    ///   - languageCode: One of the language codes listed in the available translations.
    /// - returns: The `Form` requested with translated values.
    /// - throws: `TypeformError`, `URLError`, `DecodingError`
    func translatedTo(_ languageCode: Locale.LanguageCode) async throws -> Form {
        guard settings.languageCode != languageCode else {
            return self
        }

        guard settings.translationLanguageCodes.contains(languageCode) else {
            throw TypeformError.notAvailableInLanguage
        }

        guard let url = URL(string: "https://api.typeform.com/forms/\(id)/translation/\(languageCode.identifier)") else {
            throw TypeformError.parseURL
        }

        let request = URLRequest(url: url)
        let response = try await URLSession.shared.data(for: request)
        let translation = try Self.decoder.decode(TranslatedForm.self, from: response.0)
        return merging(translatedForm: translation)
    }
}
