import Foundation

public enum TemplaterPlaceholderType: String, RawRepresentable, Codable, Sendable {
    case integer
    case double
    case object
    case string
    case boolean
}

public struct TemplaterProvidedPlaceholder: Codable, Sendable {
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

public struct TemplaterRenderedPlaceholder: Codable, Sendable {
    public let placeholder: String
    public let using: [String] // maps to provided vars
    public let constructor: TemplaterPlaceholderConstructor // maps to constructors enum / protocol / type?
    public let type: TemplaterPlaceholderType?
    public let required: Bool
    
    public init(
        placeholder: String,
        using: [String],
        constructor: TemplaterPlaceholderConstructor,
        type: TemplaterPlaceholderType?,
        required: Bool = true
    ) {
        self.placeholder = placeholder
        self.using = using
        self.constructor = constructor
        self.type = type
        self.required = required
    }
}

public struct TemplaterPlaceholders: Codable, Sendable {
    public let provided: [TemplaterProvidedPlaceholder]
    public let rendered: [TemplaterRenderedPlaceholder]
    
    public init(
        provided: [TemplaterProvidedPlaceholder] = [],
        rendered: [TemplaterRenderedPlaceholder] = []
    ) {
        self.provided = provided
        self.rendered = rendered
    }
}
