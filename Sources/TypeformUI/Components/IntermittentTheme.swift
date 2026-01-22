#if canImport(SwiftUI)
import SwiftUI

public struct IntermittentTheme: Sendable {
    public let unselectedBackgroundColor: Color
    public let unselectedStrokeColor: Color
    public let unselectedStrokeWidth: Double
    public let unselectedForegroundColor: Color
    public let selectedBackgroundColor: Color
    public let selectedStrokeColor: Color
    public let selectedStrokeWidth: Double
    public let selectedForegroundColor: Color

    public init(
        unselectedBackgroundColor: Color = .white,
        unselectedStrokeColor: Color = .black,
        unselectedStrokeWidth: Double = 1.0,
        unselectedForegroundColor: Color = .black,
        selectedBackgroundColor: Color = .blue,
        selectedStrokeColor: Color = .blue,
        selectedStrokeWidth: Double = 2.0,
        selectedForegroundColor: Color = .white,
    ) {
        self.unselectedBackgroundColor = unselectedBackgroundColor
        self.unselectedStrokeColor = unselectedStrokeColor
        self.unselectedStrokeWidth = unselectedStrokeWidth
        self.unselectedForegroundColor = unselectedForegroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedStrokeColor = selectedStrokeColor
        self.selectedStrokeWidth = selectedStrokeWidth
        self.selectedForegroundColor = selectedForegroundColor
    }
}

public extension IntermittentTheme {
    static let upload: IntermittentTheme = IntermittentTheme()
    static let button: IntermittentTheme = IntermittentTheme()
    static let checkbox: IntermittentTheme = IntermittentTheme()
    static let radio: IntermittentTheme = IntermittentTheme(
        selectedBackgroundColor: .white,
        selectedStrokeColor: .black,
        selectedForegroundColor: .blue,
    )
    static let rating: IntermittentTheme = IntermittentTheme(
        selectedForegroundColor: .blue,
    )
    static let opinionScale: IntermittentTheme = IntermittentTheme()
}
#endif
