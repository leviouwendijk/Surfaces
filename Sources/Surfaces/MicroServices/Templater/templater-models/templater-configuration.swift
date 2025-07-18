import Foundation
import plate

public enum TemplaterUseDesignation: String, RawRepresentable, Codable, Sendable {
    case `internal`
    case `public`
}

public struct TemplaterTemplateConfiguration: Codable, Sendable {
    public let subject: String?
    public let placeholders: [TemplaterPlaceholder]?
    public let allowedReturnTypes: [DocumentExtensionType]?
    public let use: [TemplaterUseDesignation]?
    
    public init(
        subject: String?,
        placeholders: [TemplaterPlaceholder]? = nil,
        allowedReturnTypes: [DocumentExtensionType]? = [.html, .txt, .pdf], // add .rtf, .norg, .docx
        use: [TemplaterUseDesignation]? = nil
    ) {
        self.subject = subject
        self.placeholders = placeholders
        self.allowedReturnTypes = allowedReturnTypes
        self.use = use
    }
}
