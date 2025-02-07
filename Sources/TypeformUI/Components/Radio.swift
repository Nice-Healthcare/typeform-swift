#if canImport(SwiftUI)
import SwiftUI

struct Radio: View {

    let radio: Settings.Radio
    let selected: Bool

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(selected ? radio.theme.selectedBackgroundColor : radio.theme.unselectedBackgroundColor)

            Circle()
                .stroke(selected ? radio.theme.selectedStrokeColor : radio.theme.unselectedStrokeColor, lineWidth: 1.0)

            if selected {
                Circle()
                    .foregroundColor(radio.theme.selectedForegroundColor)
                    .padding(4)
            }
        }
        .aspectRatio(1.0, contentMode: .fill)
    }
}

struct Radio_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Radio(
                radio: Settings.Radio(),
                selected: false
            )

            Radio(
                radio: Settings.Radio(),
                selected: true
            )
        }
        .frame(width: 20, height: 20)
    }
}
#endif
