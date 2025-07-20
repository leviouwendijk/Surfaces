import Foundation
import Structures
import plate

public enum TemplaterUseDesignation: String, RawRepresentable, Codable, Sendable {
    case `internal`
    case `public`
}

public struct TemplaterTemplateConfiguration: Codable, Sendable {
    public let language: LanguageSpecifier
    public let subject: String?
    public let placeholders: TemplaterPlaceholders?
    public let defaults: [String: JSONValue]?
    public let labels: [GeneralizedLabel]?
    public let allowedReturnTypes: [DocumentExtensionType]?
    public let use: [TemplaterUseDesignation]?
    
    public init(
        language: LanguageSpecifier,
        subject: String?,
        placeholders: TemplaterPlaceholders? = nil,
        defaults: [String: JSONValue]? = nil,
        labels: [GeneralizedLabel]?,
        allowedReturnTypes: [DocumentExtensionType]? = [.html, .txt, .pdf], // add .rtf, .norg, .docx
        use: [TemplaterUseDesignation]? = nil
    ) {
        self.language = language
        self.subject = subject
        self.placeholders = placeholders
        self.defaults = defaults
        self.labels = labels
        self.allowedReturnTypes = allowedReturnTypes
        self.use = use
    }
}
