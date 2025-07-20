import Foundation
import Structures
import plate

public enum TemplaterSection: String, RawRepresentable, Codable, Sendable {
    case image
    case template
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
    case base // regular?
    case expanded // extended?
    case short // simple?
    case training
}

// example directory
// ..Resources/<platform>/<group>/<type>/<variant>/<language>.html <-- containes raw text with {{placeholders}}
// .............................................../<language>.json  <-- contains required variables + subject with any placeholders

public struct TemplaterTemplatePath: Codable, Sendable {
    public let section: TemplaterSection // template, image
    public let platform: TemplaterPlatform // document / mail
    public let group: TemplaterGroup // billing / appointment
    public let type: TemplaterType // invoice / confirmation
    public let variant: TemplaterVariant // base, training, particulars
    public let language: LanguageSpecifier
    
    public init(
        section: TemplaterSection,
        platform: TemplaterPlatform,
        group: TemplaterGroup,
        type: TemplaterType,
        variant: TemplaterVariant,
        language: LanguageSpecifier,
    ) {
        self.section = section
        self.platform = platform
        self.group = group
        self.type = type
        self.variant = variant
        self.language = language
    }

    public var cssPath: String {
        [
            section.rawValue,
            platform.rawValue,
            // group.rawValue,
            // type.rawValue,
            // variant.rawValue,
            // language.code
        ]
        .joined(separator: "/") + "/styles.css"
    }

    public func cssURL(resourcesURL: URL) -> URL {
        return resourcesURL.appendingPathComponent(cssPath)
    }

    public var basePath: String {
        [
            section.rawValue,
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
