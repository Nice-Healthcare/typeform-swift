#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct IntermittentChoiceButtonStyle: ButtonStyle {

    enum IndicatorStyle {
        case radio
        case checkbox
    }

    let style: IndicatorStyle
    let selected: Bool
    let settings: Settings

    init(style: IndicatorStyle = .radio, selected: Bool, settings: Settings) {
        self.style = style
        self.selected = selected
        self.settings = settings
    }

    init(allowsMultipleSelection: Bool, selected: Bool, settings: Settings) {
        style = allowsMultipleSelection ? .checkbox : .radio
        self.selected = selected
        self.settings = settings
    }

    private var backgroundColor: Color {
        selected ? settings.button.theme.selectedBackgroundColor : settings.button.theme.unselectedBackgroundColor
    }

    private var strokeColor: Color {
        selected ? settings.button.theme.selectedStrokeColor : settings.button.theme.unselectedStrokeColor
    }

    private var strokeWidth: Double {
        selected ? settings.button.theme.selectedStrokeWidth : settings.button.theme.unselectedStrokeWidth
    }

    private var foregroundColor: Color {
        settings.typography.bodyColor
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: settings.button.cornerRadius)
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Group {
                switch style {
                case .radio:
                    Radio(
                        radio: settings.radio,
                        selected: selected
                    )
                case .checkbox:
                    Checkbox(
                        checkbox: settings.checkbox,
                        selected: selected
                    )
                }
            }
            .frame(width: 20, height: 20)

            configuration.label
                .font(settings.typography.bodyFont)
                .foregroundColor(foregroundColor)
        }
        .padding(settings.button.padding)
        .background(
            backgroundColor.clipShape(shape)
        )
        .overlay(
            shape.stroke(strokeColor, lineWidth: strokeWidth)
        )
    }
}

struct IntermittentChoiceButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MultipleChoiceView(
                state: .constant(ResponseState()),
                properties: .preview_One,
                settings: Settings()
            )
            .padding()
        }
        .previewDisplayName("Single Selection")

        ScrollView {
            MultipleChoiceView(
                state: .constant(ResponseState()),
                properties: .preview_Many,
                settings: Settings()
            )
            .padding()
        }
        .previewDisplayName("Multiple Selection")
    }
}
#endif
