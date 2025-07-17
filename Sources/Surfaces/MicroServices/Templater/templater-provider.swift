import Foundation
import plate

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

    private static let candidateExtensions: [DocumentExtensionType] = [
        .html, .txt, .css, .rtf, .docx
    ]

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func fetchTemplate(
            at templatePath: TemplaterTemplatePath
    ) throws -> String {
        let fm = FileManager.default

        for ext in Self.candidateExtensions {
            let fileName = templatePath.basePath + ext.dotPrefixed
            let fileURL  = baseURL.appendingPathComponent(fileName)

            if fm.fileExists(atPath: fileURL.path) {
                do {
                    let str = try String(contentsOf: fileURL, encoding: .utf8)
                    return str
                } catch {
                    throw TemplateError.unreadable(path: fileURL.path, underlying: error)
                }
            }
        }

        let tried = Self.candidateExtensions
        .map(\.dotPrefixed)
        .joined(separator: ", ")

        let missingPath = baseURL
        .appendingPathComponent(templatePath.basePath)
        .path

        throw TemplateError.notFound(
            path: "\(missingPath).(\(tried))"
        )
    }
}
