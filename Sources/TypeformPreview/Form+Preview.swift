import Foundation
import Typeform

public extension Form {
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    static var medicalIntake22: Form = {
        guard let url = Bundle.typeformPreview.url(forResource: "MedicalIntake", withExtension: "json") else {
            preconditionFailure("Unable to locate 'MedicalIntake.json' in Bundle.module.")
        }

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(Form.self, from: data)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }()
    
    static var medicalIntake23: Form = {
        guard let url = Bundle.typeformPreview.url(forResource: "MedicalIntake23", withExtension: "json") else {
            preconditionFailure("Unable to locate 'MedicalIntake.json' in Bundle.module.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(Form.self, from: data)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }()
}

public extension WelcomeScreen {
    static var preview: WelcomeScreen = {
        guard let screen = Form.medicalIntake23.welcomeScreens.first else {
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
