import Foundation
import Typeform

public extension Form {
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private static func intakeForm(_ resource: String) -> Form {
        guard let url = Bundle.typeformPreview.url(forResource: resource, withExtension: "json") else {
            preconditionFailure("Unable to locate '\(resource).json' in Bundle.module.")
        }

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(Form.self, from: data)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }

    static var medicalIntake22 = intakeForm("MedicalIntake")
    static var medicalIntake23 = intakeForm("MedicalIntake23")
    static var medicalIntake24 = intakeForm("MedicalIntake24")
    static var medicalIntake26 = intakeForm("MedicalIntake26")
    static var medicalIntake35 = intakeForm("MedicalIntake35")
    static var genericSlugs = intakeForm("GenericSlugs")
    static let ptIntake42 = intakeForm("PTIntake42")
    static let primaryCare3 = intakeForm("PrimaryCareV3")
    static let physicalTherapy3 = intakeForm("PhysicalTherapyV3")
    static let healthHistory3 = intakeForm("HealthHistoryV3")
}

public extension WelcomeScreen {
    static var preview: WelcomeScreen = {
        guard let screen = Form.medicalIntake23.welcomeScreens?.first else {
            preconditionFailure("Failed to find first 'WelcomeScreen'.")
        }

        return screen
    }()
}

public extension EndingScreen {
    static var preview: EndingScreen = {
        guard let screen = Form.medicalIntake23.endingScreens.first else {
            preconditionFailure("Failed to find default 'EndingScreen'.")
        }

        return screen
    }()

    static var `default`: EndingScreen = {
        guard let screen = Form.medicalIntake23.endingScreens.first(where: { $0.ref == .default }) else {
            preconditionFailure("Failed to find default 'EndingScreen'.")
        }

        return screen
    }()
}
