import Foundation

public enum TemplateError: Error, LocalizedError, Sendable {
    case notFound(path: String)
    case unreadable(path: String, underlying: Error)

    public var errorDescription: String? {
        switch self {
        case let .notFound(path):
            return "Template file not found at path: \(path)"
        case let .unreadable(path, underlying):
            return "Couldn’t read template at \(path): \(underlying.localizedDescription)"
        }
    }
}

public protocol TemplaterTemplateProviding: Sendable {
    func fetchTemplate(at templatePath: TemplaterTemplatePath) throws -> String
}

public struct TemplaterTemplateProvider: TemplaterTemplateProviding, Sendable {
    public let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func fetchTemplate(at templatePath: TemplaterTemplatePath) throws -> String {
        let fileURL = baseURL.appendingPathComponent(templatePath.fileName)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw TemplateError.notFound(path: fileURL.path)
        }

        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            throw TemplateError.unreadable(path: fileURL.path, underlying: error)
        }
    }
}
