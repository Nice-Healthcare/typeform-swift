#if canImport(SwiftUI)
import SwiftUI

struct FieldStyleViewModifier: ViewModifier {

    let settings: TypeformUI.Settings

    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: settings.field.cornerRadius) }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, settings.field.horizontalInset)
            .padding(.vertical, settings.field.verticalInset)
            .background(
                settings.field.backgroundColor.clipShape(shape)
            )
            .overlay(
                shape.stroke(settings.field.strokeColor, lineWidth: settings.field.strokeWidth)
            )
    }
}

extension View {
    func fieldStyle(settings: TypeformUI.Settings) -> some View {
        modifier(FieldStyleViewModifier(settings: settings))
    }
}

struct FieldStyleViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Elements")
        }
        .fieldStyle(settings: Settings())
    }
}
#endif
