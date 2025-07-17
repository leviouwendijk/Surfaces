import Foundation
import Structures
import plate

public enum TemplaterDesignation: String, RawRepresentable, Codable, Sendable {
    case `internal`
    case `public`
}

public enum TemplaterPlatform: String, RawRepresentable, Codable, Sendable {
    case mail
    case document
    case whatsapp
}

public enum TemplaterGroup: String, RawRepresentable, Codable, Sendable {
    case lead
    case agreement
    case appointment
    case invoice
    case quote
    case service
    case resolution
    // case account
}

public enum TemplaterType: String, RawRepresentable, Codable, Sendable {
    case confirmation
    case issuance
    case expiration
    case review
}

public enum TemplaterVariant: String, RawRepresentable, Codable, Sendable {
    case base
    case expanded
    case short
}


// example directory
// ..Resources/<platform>/<group>/<type>/<variant>/<language>.html <-- containes raw text with {{placeholders}}
// .............................................../<language>.json  <-- contains required variables + subject with any placeholders

public struct TemplaterTemplatePath: Codable, Sendable {
    public let platform: TemplaterPlatform
    public let group: TemplaterGroup
    public let type: TemplaterType
    public let designation: TemplaterDesignation
    public let variant: TemplaterVariant
    public let language: LanguageSpecifier
    // public let document: DocumentExtensionType
    
    public init(
        platform: TemplaterPlatform,
        group: TemplaterGroup,
        type: TemplaterType,
        designation: TemplaterDesignation,
        variant: TemplaterVariant,
        language: LanguageSpecifier,
        // document: DocumentExtensionType
    ) {
        self.platform = platform
        self.group = group
        self.type = type
        self.designation = designation
        self.variant = variant
        self.language = language
        // self.document = document
    }

    public var basePath: String {
        [
            platform.rawValue,
            group.rawValue,
            type.rawValue,
            variant.rawValue,
            language.code
        ]
        .joined(separator: "/")
    }

    // public var configFile: String {
    //     basePath + DocumentExtensionType.json.dotPrefixed
    // }
}
