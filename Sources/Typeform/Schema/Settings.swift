import Foundation

public struct Settings: Hashable, Decodable {
    
    public struct Meta: Hashable, Decodable {
        public let allow_indexing: Bool
    }
    
    public struct Capabilities: Hashable, Decodable {
        
        public struct EndToEndEncryption: Hashable, Decodable {
            public let enabled: Bool
            public let modifiable: Bool
        }
        
        public let e2e_encryption: EndToEndEncryption
    }
    
    public let meta: Meta
    public let is_trial: Bool
    public let language: String
    public let is_public: Bool
    public let capabilities: Capabilities
    public let progress_bar: String
    public let hide_navigation: Bool
    public let show_progress_bar: Bool
    public let are_uploads_public: Bool
    public let show_cookie_consent: Bool
    public let show_question_number: Bool
    public let pro_subdomain_enabled: Bool
    public let show_time_to_complete: Bool
    public let show_typeform_branding: Bool
    public let show_number_of_submissions: Bool
}
