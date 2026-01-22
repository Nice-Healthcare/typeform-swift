#if canImport(SwiftUI)
import SwiftUI
import Typeform
import TypeformPreview

struct UploadLabelStyle: LabelStyle {

    let settings: Settings

    private var backgroundColor: Color {
        settings.upload.theme.unselectedBackgroundColor
    }

    private var strokeColor: Color {
        settings.upload.theme.unselectedStrokeColor
    }

    private var strokeWidth: Double {
        settings.upload.theme.unselectedStrokeWidth
    }

    private var foregroundColor: Color {
        settings.typography.bodyColor
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: settings.upload.actionRadius)
    }

    init(settings: Settings) {
        self.settings = settings
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
        .font(settings.typography.bodyFont)
        .foregroundColor(foregroundColor)
        .frame(maxWidth: .infinity)
        .padding(settings.button.padding)
        .background(
            backgroundColor.clipShape(shape),
        )
        .overlay(
            shape.stroke(strokeColor, lineWidth: strokeWidth),
        )
    }
}

#Preview("Upload Label Style") {
    Menu {
        Button("One") {}
        Button("Two") {}
    } label: {
        Label("Add", systemImage: "plus")
            .labelStyle(
                UploadLabelStyle(
                    settings: Settings(),
                ),
            )
    }
}
#endif
