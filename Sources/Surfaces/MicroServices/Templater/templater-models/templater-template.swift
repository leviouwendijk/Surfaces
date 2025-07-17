import Foundation

public struct TemplaterTemplate: Codable, Sendable {
    public let path: TemplaterTemplatePath
    public let configuration: TemplaterTemplateConfiguration
    
    public init(
        path: TemplaterTemplatePath,
        configuration: TemplaterTemplateConfiguration
    ) {
        self.path = path
        self.configuration = configuration
    }
}
