import Foundation
import plate

public struct TemplaterTemplateConfiguration: Codable, Sendable {
    public let subject: String?
    public let placeholders: [TemplaterPlaceholder]?
    public let allowedReturnTypes: [DocumentExtensionType]?
    
    public init(
        subject: String?,
        placeholders: [TemplaterPlaceholder]? = nil,
        allowedReturnTypes: [DocumentExtensionType]? = [.html, .txt, .pdf] // add .rtf, .norg, .docx
    ) {
        self.subject = subject
        self.placeholders = placeholders
        self.allowedReturnTypes = allowedReturnTypes
    }
}
