import Foundation
import Structures

public typealias TemplateVariables = [String: JSONValue]

public struct TemplateRenderRequest: Codable, Sendable {
    public let category: String
    public let name: String
    public let variables: TemplateVariables
}

public struct TemplateRenderResponse: Codable, Sendable {
    public let success: Bool
    public let html: String
}
