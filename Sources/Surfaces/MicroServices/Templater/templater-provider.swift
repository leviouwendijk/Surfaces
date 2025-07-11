import Foundation

public protocol TemplateProvider {
    func fetchTemplate(category: String, name: String) throws -> String
}

public struct FileSystemTemplateProvider: TemplateProvider {
    public let basePath: String // e.g. "/templates/"
    public func fetchTemplate(category: String, name: String) throws -> String {
        let path = "\(basePath)/\(category)/\(name).html"
        return try String(contentsOfFile: path, encoding: .utf8)
    }
}
