#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct ChoiceButtonStyle: ButtonStyle {
    
    let allowsMultipleSelection: Bool
    let selected: Bool
    let settings: Settings
    
    private var backgroundColor: Color {
        selected ? settings.interaction.selectedBackgroundColor : settings.interaction.unselectedBackgroundColor
    }
    
    private var strokeColor: Color {
        selected ? settings.interaction.selectedStrokeColor : settings.interaction.unselectedStrokeColor
    }
    
    private var strokeWidth: Double {
        selected ? settings.interaction.selectedStrokeWidth : settings.interaction.unselectedStrokeWidth
    }
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: settings.interaction.contentCornerRadius)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                if allowsMultipleSelection {
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
                } else {
                    Circle()
                        .foregroundColor(selected ? settings.radio.selectedBackgroundColor : settings.radio.unselectedBackgroundColor)
                    
                    Circle()
                        .stroke(selected ? settings.radio.selectedStrokeColor : settings.radio.unselectedStrokeColor, lineWidth: 1.0)
                    
                    if selected {
                        Circle()
                            .foregroundColor(settings.radio.selectedForegroundColor)
                            .padding(4)
                    }
                }
            }
            .frame(width: 20, height: 20)
            
            configuration.label
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
    }
}
#endif
