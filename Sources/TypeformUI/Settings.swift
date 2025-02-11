#if canImport(SwiftUI)
import SwiftUI

/// Control the layout behaviors and styling of a `Form` presentation.
public struct Settings {

    public struct Localization {
        public var next: String
        public var cancel: String
        public var finish: String
        public var yes: String
        public var no: String
        public var exit: String
        public var abandonConfirmationTitle: String
        public var abandonConfirmationMessage: String
        public var abandonConfirmationAction: String
        public var emptyChoice: String
        public var nullDate: String

        public init(
            next: String = "Next",
            cancel: String = "Cancel",
            finish: String = "Finish",
            yes: String = "Yes",
            no: String = "No",
            exit: String = "Exit",
            abandonConfirmationTitle: String = "Abandon Form?",
            abandonConfirmationMessage: String = "Are you sure you want to abandon the form?",
            abandonConfirmationAction: String = "Abandon",
            emptyChoice: String = "Select Option",
            nullDate: String = "I'm not sure…"
        ) {
            self.next = next
            self.cancel = cancel
            self.finish = finish
            self.yes = yes
            self.no = no
            self.exit = exit
            self.abandonConfirmationAction = abandonConfirmationAction
            self.abandonConfirmationTitle = abandonConfirmationTitle
            self.abandonConfirmationMessage = abandonConfirmationMessage
            self.emptyChoice = emptyChoice
            self.nullDate = nullDate
        }
    }

    public enum Layout {
        case callToAction
        case navigation
        case inline
    }

    public struct Presentation {
        public var layout: Layout
        public var backgroundColor: Color
        public var titleDescriptionVerticalSpacing: Double
        public var descriptionContentVerticalSpacing: Double
        public var contentInsets: EdgeInsets
        public var contentVerticalSpacing: Double
        @available(*, deprecated, message: "No-longer respected.")
        public var showWelcomeImage: Bool
        @available(*, deprecated, message: "No-longer respected.")
        public var showEndingImage: Bool
        public var skipWelcomeScreen: Bool
        public var skipEndingScreen: Bool

        public init(
            layout: Layout = .callToAction,
            backgroundColor: Color = .white,
            titleDescriptionVerticalSpacing: Double = 30.0,
            descriptionContentVerticalSpacing: Double = 30.0,
            contentInsets: EdgeInsets = EdgeInsets(),
            contentVerticalSpacing: Double = 15.0,
            showWelcomeImage: Bool = true,
            showEndingImage: Bool = true,
            skipWelcomeScreen: Bool = false,
            skipEndingScreen: Bool = false
        ) {
            self.layout = layout
            self.backgroundColor = backgroundColor
            self.titleDescriptionVerticalSpacing = titleDescriptionVerticalSpacing
            self.descriptionContentVerticalSpacing = descriptionContentVerticalSpacing
            self.contentInsets = contentInsets
            self.contentVerticalSpacing = contentVerticalSpacing
            self.showWelcomeImage = showWelcomeImage
            self.showEndingImage = showEndingImage
            self.skipWelcomeScreen = skipWelcomeScreen
            self.skipEndingScreen = skipEndingScreen
        }
    }

    public struct Typography {
        public var titleFont: Font
        public var titleColor: Color
        public var promptFont: Font
        public var promptColor: Color
        public var bodyFont: Font
        public var bodyColor: Color
        public var captionFont: Font
        public var captionColor: Color

        /// Initialize Typography Settings
        ///
        /// - parameters:
        ///   - titleFont: `Font` applied to `Screen.title` and `Field.title` blocks.
        ///   - titleColor: `Color` applied to `Screen.title` and `Field.title` blocks.
        ///   - promptFont: `Font` applied to supplemental text blocks, like Date toggle.
        ///   - promptColor: `Color` applied to supplemental text blocks, like Date toggle.
        ///   - bodyFont: `Font` applied to any other text element.
        ///   - bodyColor: `Color` applied to any other text element.
        ///   - captionFont: `Font` applied to `Field.properties.description` blocks.
        ///   - captionColor: `Color` applied to `Field.properties.description` blocks.
        public init(
            titleFont: Font = .title,
            titleColor: Color = .black,
            promptFont: Font = .body,
            promptColor: Color = .gray,
            bodyFont: Font = .body,
            bodyColor: Color = .black,
            captionFont: Font = .caption,
            captionColor: Color = .gray
        ) {
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.promptFont = promptFont
            self.promptColor = promptColor
            self.bodyFont = bodyFont
            self.bodyColor = bodyColor
            self.captionFont = captionFont
            self.captionColor = captionColor
        }
    }

    public struct CallToAction {
        public var backgroundColor: Color
        public var dividerColor: Color
        public var insets: EdgeInsets
        public var verticalSpacing: Double

        public init(
            backgroundColor: Color = .white,
            dividerColor: Color = .black,
            insets: EdgeInsets = EdgeInsets(),
            verticalSpacing: Double = 0.0
        ) {
            self.backgroundColor = backgroundColor
            self.dividerColor = dividerColor
            self.insets = insets
            self.verticalSpacing = verticalSpacing
        }
    }

    public struct Field {
        public var backgroundColor: Color
        public var strokeColor: Color
        public var strokeWidth: Double
        public var verticalInset: Double
        public var horizontalInset: Double
        public var cornerRadius: Double

        public init(
            backgroundColor: Color = .gray.opacity(0.2),
            strokeColor: Color = .gray.opacity(0.8),
            strokeWidth: Double = 1.0,
            verticalInset: Double = 10.0,
            horizontalInset: Double = 15.0,
            cornerRadius: Double = 6.0
        ) {
            self.backgroundColor = backgroundColor
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
            self.verticalInset = verticalInset
            self.horizontalInset = horizontalInset
            self.cornerRadius = cornerRadius
        }
    }

    public struct Button {
        public var theme: IntermittentTheme
        public var cornerRadius: Double
        public var padding: EdgeInsets

        public init(
            theme: IntermittentTheme = .button,
            cornerRadius: Double = 6.0,
            padding: EdgeInsets = EdgeInsets(top: 15.0, leading: 10.0, bottom: 15.0, trailing: 10.0)
        ) {
            self.theme = theme
            self.cornerRadius = cornerRadius
            self.padding = padding
        }
    }

    public struct Checkbox {
        public var theme: IntermittentTheme
        public var cornerRadius: Double

        public init(
            theme: IntermittentTheme = .checkbox,
            cornerRadius: Double = 3.0
        ) {
            self.theme = theme
            self.cornerRadius = cornerRadius
        }
    }

    public struct Radio {
        public var theme: IntermittentTheme

        public init(
            theme: IntermittentTheme = .radio
        ) {
            self.theme = theme
        }
    }

    public struct Rating {
        public var theme: IntermittentTheme

        public init(
            theme: IntermittentTheme = .rating
        ) {
            self.theme = theme
        }
    }

    public struct OpinionScale {
        public init() {}
    }

    public var localization: Localization
    public var presentation: Presentation
    public var typography: Typography
    public var callToAction: CallToAction
    public var field: Field
    public var button: Button
    public var checkbox: Checkbox
    public var radio: Radio
    public var rating: Rating
    public var opinionScale: OpinionScale

    public init(
        localization: Localization = Localization(),
        presentation: Presentation = Presentation(),
        typography: Typography = Typography(),
        callToAction: CallToAction = CallToAction(),
        field: Field = Field(),
        button: Button = Button(),
        checkbox: Checkbox = Checkbox(),
        radio: Radio = Radio(),
        rating: Rating = Rating(),
        opinionScale: OpinionScale = OpinionScale()
    ) {
        self.localization = localization
        self.presentation = presentation
        self.typography = typography
        self.callToAction = callToAction
        self.field = field
        self.button = button
        self.checkbox = checkbox
        self.radio = radio
        self.rating = rating
        self.opinionScale = opinionScale
    }
}
#endif
