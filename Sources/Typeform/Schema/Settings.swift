import Foundation

public struct Settings: Hashable, Codable {
    
    public struct Meta: Hashable, Codable {
        public let allow_indexing: Bool
        
        public init(allow_indexing: Bool = false) {
            self.allow_indexing = allow_indexing
        }
    }
    
    public struct Capabilities: Hashable, Codable {
        
        public struct EndToEndEncryption: Hashable, Codable {
            public let enabled: Bool
            public let modifiable: Bool
            
            public init(
                enabled: Bool = false,
                modifiable: Bool = false
            ) {
                self.enabled = enabled
                self.modifiable = modifiable
            }
        }
        
        public let e2e_encryption: EndToEndEncryption
        
        public init(
            e2e_encryption: EndToEndEncryption = .init()
        ) {
            self.e2e_encryption = e2e_encryption
        }
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
    
    public init(
        meta: Meta = .init(),
        is_trial: Bool = false,
        language: String = "",
        is_public: Bool = false,
        capabilities: Capabilities = .init(),
        progress_bar: String = "",
        hide_navigation: Bool = false,
        show_progress_bar: Bool = false,
        are_uploads_public: Bool = false,
        show_cookie_consent: Bool = false,
        show_question_number: Bool = false,
        pro_subdomain_enabled: Bool = false,
        show_time_to_complete: Bool = false,
        show_typeform_branding: Bool = false,
        show_number_of_submissions: Bool = false
    ) {
        self.meta = meta
        self.is_trial = is_trial
        self.language = language
        self.is_public = is_public
        self.capabilities = capabilities
        self.progress_bar = progress_bar
        self.hide_navigation = hide_navigation
        self.show_progress_bar = show_progress_bar
        self.are_uploads_public = are_uploads_public
        self.show_cookie_consent = show_cookie_consent
        self.show_question_number = show_question_number
        self.pro_subdomain_enabled = pro_subdomain_enabled
        self.show_time_to_complete = show_time_to_complete
        self.show_typeform_branding = show_typeform_branding
        self.show_number_of_submissions = show_number_of_submissions
    }
}
