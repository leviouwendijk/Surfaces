import Foundation
import Structures
import plate

public enum TemplaterImageGroup: String, RawRepresentable, Codable, Sendable {
    case logomark
    case wordmark
}

public enum TemplaterImageIdentifier: String, RawRepresentable, Codable, Sendable {
    case h
    case hondenmeesters
}

public enum TemplaterImageRenderType: String, RawRepresentable, Codable, Sendable {
    case background
    case transparent
}

public enum TemplaterImageVariant: String, RawRepresentable, Codable, Sendable {
    case regular
}

public struct TemplaterImagePath: Codable, Sendable {
    public let section: TemplaterSection
    public let group: TemplaterImageGroup 
    public let identifier: TemplaterImageIdentifier 
    public let render: TemplaterImageRenderType
    public let variant: TemplaterImageVariant
    public let document: DocumentExtensionType
    
    public init(
        section: TemplaterSection,
        group: TemplaterImageGroup,
        identifier: TemplaterImageIdentifier,
        render: TemplaterImageRenderType,
        variant: TemplaterImageVariant,
        document: DocumentExtensionType 
    ) {
        self.section = section
        self.group = group
        self.identifier = identifier
        self.render = render
        self.variant = variant
        self.document = document
    }

    public var basePath: String {
        [
            section.rawValue,
            group.rawValue,
            identifier.rawValue,
            render.rawValue,
            variant.rawValue
        ]
        .joined(separator: "/")
    }

    public var extendedPath: String {
        return basePath + document.dotPrefixed
    }
}
