import Foundation
import Structures
import plate

public typealias TemplaterTemplateVariables = [String: JSONValue]

public struct TemplaterRenderRequest: Codable, Sendable {
    public let template: TemplaterTemplatePath
    public let variables:  TemplaterTemplateVariables
    public let returning:  DocumentExtensionType
    
    public init(
        template: TemplaterTemplatePath,
        variables: TemplaterTemplateVariables,
        returning: DocumentExtensionType
    ) {
        self.template = template
        self.variables = variables
        self.returning = returning
    }
}
