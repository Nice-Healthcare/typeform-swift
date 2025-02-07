#if canImport(SwiftUI)
import SwiftUI

struct Checkbox: View {

    let checkbox: Settings.Checkbox
    let selected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: checkbox.cornerRadius)
                .foregroundColor(selected ? checkbox.theme.selectedBackgroundColor : checkbox.theme.unselectedBackgroundColor)

            RoundedRectangle(cornerRadius: checkbox.cornerRadius)
                .stroke(selected ? checkbox.theme.selectedStrokeColor : checkbox.theme.unselectedStrokeColor, lineWidth: 1.0)

            if selected {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(checkbox.theme.selectedForegroundColor)
                    .padding(4)
            }
        }
        .aspectRatio(1.0, contentMode: .fill)
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Checkbox(
                checkbox: Settings.Checkbox(),
                selected: false
            )

            Checkbox(
                checkbox: Settings.Checkbox(),
                selected: true
            )
        }
        .frame(width: 20, height: 20)
    }
}
#endif
