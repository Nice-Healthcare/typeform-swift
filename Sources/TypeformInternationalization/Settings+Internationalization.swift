import Foundation
import Typeform

public extension Settings {
    var locale: Locale {
        Locale(identifier: language)
    }

    var languageCode: Locale.LanguageCode? {
        Locale.LanguageCode(language).isoLanguageCodeOrNil
    }

    var translationLanguageCodes: [Locale.LanguageCode] {
        guard let translation_languages, !translation_languages.isEmpty else {
            return []
        }

        return translation_languages.compactMap {
            Locale.LanguageCode($0).isoLanguageCodeOrNil
        }
    }
}

extension Locale.LanguageCode {
    var isoLanguageCodeOrNil: Self? {
        #if canImport(FoundationInternationalization)
        guard isISOLanguage else {
            return nil
        }

        return self
        #elseif canImport(FoundationEssentials)
        return self
        #else
        guard isISOLanguage else {
            return nil
        }

        return self
        #endif
    }
}
