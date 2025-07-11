import Foundation

public enum TemplaterCategory: String, RawRepresentable, Codable, Sendable {
    case appointment
    case invoice
    case lead
    case quote
    case service
    case resolution
    case account
}

// public enum TemplaterFile: String, RawRepresentable, Codable, Sendable {
// }

public struct TemplaterEmailTemplate: Codable, Sendable {
    public let key: String          // e.g. "appointment-confirmation"
    public let category: String     // e.g. "appointment"
    public let name: String         // e.g. "confirmation"
    public let subject: String
    public let variables: [String]  // required variable names
}

public struct TemplaterTemplateCatalog: Codable, Sendable {
    public let templates: [String: TemplaterEmailTemplate] // keyed by key ("category-name")
}
