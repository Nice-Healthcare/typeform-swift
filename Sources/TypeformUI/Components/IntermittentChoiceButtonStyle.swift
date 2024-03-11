#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct IntermittentChoiceButtonStyle: ButtonStyle {
    
    enum IndicatorStyle {
        case radio
        case checkbox
    }
    
    let style: IndicatorStyle?
    let selected: Bool
    let settings: Settings
    
    init(style: IndicatorStyle? = nil, selected: Bool, settings: Settings) {
        self.style = style
        self.selected = selected
        self.settings = settings
    }
    
    init(allowsMultipleSelection: Bool, selected: Bool, settings: Settings) {
        self.style = allowsMultipleSelection ? .checkbox : .radio
        self.selected = selected
        self.settings = settings
    }
    
    private var backgroundColor: Color {
        if style == nil {
            selected ? settings.rating.selectedBackgroundColor : settings.rating.unselectedBackgroundColor
        } else {
            selected ? settings.interaction.selectedBackgroundColor : settings.interaction.unselectedBackgroundColor
        }
    }
    
    private var strokeColor: Color {
        if style == nil {
            selected ? settings.rating.selectedStrokeColor : settings.rating.unselectedStrokeColor
        } else {
            selected ? settings.interaction.selectedStrokeColor : settings.interaction.unselectedStrokeColor
        }
    }
    
    private var strokeWidth: Double {
        if style == .none {
            selected ? settings.rating.selectedStrokeWidth : settings.rating.unselectedStrokeWidth
        } else {
            selected ? settings.interaction.selectedStrokeWidth : settings.interaction.unselectedStrokeWidth
        }
    }
    
    private var foregroundColor: Color {
        if style == .none {
            selected ? settings.rating.selectedForegroundColor : settings.rating.unselectedForegroundColor
        } else {
            settings.typography.bodyColor
        }
    }
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: settings.interaction.contentCornerRadius)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if let style = self.style {
                ZStack {
                    switch style {
                    case .radio:
                        Circle()
                            .foregroundColor(selected ? settings.radio.selectedBackgroundColor : settings.radio.unselectedBackgroundColor)
                        
                        Circle()
                            .stroke(selected ? settings.radio.selectedStrokeColor : settings.radio.unselectedStrokeColor, lineWidth: 1.0)
                        
                        if selected {
                            Circle()
                                .foregroundColor(settings.radio.selectedForegroundColor)
                                .padding(4)
                        }
                    case .checkbox:
                        RoundedRectangle(cornerRadius: settings.checkbox.cornerRadius)
                            .foregroundColor(selected ? settings.checkbox.selectedBackgroundColor : settings.checkbox.unselectedBackgroundColor)
                        
                        RoundedRectangle(cornerRadius: settings.checkbox.cornerRadius)
                            .stroke(selected ? settings.checkbox.selectedStrokeColor : settings.checkbox.unselectedStrokeColor, lineWidth: 1.0)
                        
                        if selected {
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(settings.checkbox.selectedForegroundColor)
                                .padding(4)
                        }
                    }
                }
                .frame(width: 20, height: 20)
            }
            
            configuration.label
                .foregroundColor(foregroundColor)
        }
        .padding(.vertical, settings.interaction.contentVerticalInset)
        .padding(.horizontal, settings.interaction.contentHorizontalInset)
        .background(
            backgroundColor.clipShape(shape)
        )
        .overlay(
            shape.stroke(strokeColor, lineWidth: strokeWidth)
        )
    }
}

struct ChoiceButtonStyle_Previews: PreviewProvider {
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
        
        ScrollView {
            OpinionScaleView(
                state: .constant(ResponseState()),
                properties: .preview,
                settings: Settings()
            )
        }
        .previewDisplayName("Opinion Selection")
    }
}
#endif
