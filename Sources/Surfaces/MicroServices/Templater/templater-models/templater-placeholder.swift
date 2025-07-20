import Foundation

public enum TemplaterPlaceholderType: String, RawRepresentable, Codable, Sendable {
    case integer
    case double
    case object
    case string
}

public struct TemplaterPlaceholder: Codable, Sendable {
    public let placeholder: String
    public let type: TemplaterPlaceholderType?
    public let required: Bool
    
    public init(
        placeholder: String,
        type: TemplaterPlaceholderType?,
        required: Bool = true
    ) {
        self.placeholder = placeholder
        self.type = type
        self.required = required
    }
}

public struct TemplaterPlaceholders: Codable, Sendable {
    public let provided: [TemplaterPlaceholder]
    public let rendered: [TemplaterPlaceholder]
    
    public init(
        provided: [TemplaterPlaceholder],
        rendered: [TemplaterPlaceholder]
    ) {
        self.provided = provided
        self.rendered = rendered
    }
}
