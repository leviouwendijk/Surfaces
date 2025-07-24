import Foundation
import Structures
import plate

public enum TemplaterUseDesignation: String, RawRepresentable, Codable, Sendable {
    case `internal`
    case `public`
}

public enum TemplaterStyleSpecifier: String, RawRepresentable, Codable, Sendable {
    case keep
    case replace
    // case merge
}

public struct TemplaterTemplateConfiguration: Codable, Sendable {
    public let language: LanguageSpecifier
    public let subject: String?
    public let placeholders: TemplaterPlaceholders
    public let defaults: [String: JSONValue]?
    public let labels: [GeneralizedLabel]?
    public let images: [TemplaterImage]
    public let styles: TemplaterStyleSpecifier
    public let allowedReturnTypes: [DocumentExtensionType]?
    public let use: [TemplaterUseDesignation]?
    
    public init(
        language: LanguageSpecifier,
        subject: String?,
        placeholders: TemplaterPlaceholders,
        defaults: [String: JSONValue]? = nil,
        labels: [GeneralizedLabel]?,
        images: [TemplaterImage] = [],
        styles: TemplaterStyleSpecifier = .replace,
        allowedReturnTypes: [DocumentExtensionType]? = [.html, .txt, .pdf], // add .rtf, .norg, .docx
        use: [TemplaterUseDesignation]? = nil
    ) {
        self.language = language
        self.subject = subject
        self.placeholders = placeholders
        self.defaults = defaults
        self.labels = labels
        self.images = images
        self.styles = styles
        self.allowedReturnTypes = allowedReturnTypes
        self.use = use
    }
}
