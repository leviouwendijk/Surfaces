import Foundation
import plate

public enum TemplateConfigurationError: Error, LocalizedError, Sendable {
    case notFound(path: String)
    case unreadable(path: String, underlying: Error)
    case invalidJSON(path: String, underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .notFound(let path):
            return "Config file not found at path: \(path)"
        case .unreadable(let path, let underlying):
            return "Couldn’t read config at \(path): \(underlying.localizedDescription)"
        case .invalidJSON(let path, let underlying):
            return "Invalid JSON in config at \(path): \(underlying.localizedDescription)"
        }
    }
}

public protocol TemplaterConfigurationLoading: Sendable {
    func loadConfig(for templatePath: TemplaterTemplatePath) throws -> TemplaterTemplateConfiguration
}

public struct TemplaterConfigurationLoader: TemplaterConfigurationLoading, Sendable {
    public let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func loadConfig(for templatePath: TemplaterTemplatePath) throws -> TemplaterTemplateConfiguration {
        let fileURL = baseURL
        .appendingPathComponent(templatePath.basePath)
        .appendingPathExtension("json")

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw TemplateConfigurationError.notFound(path: fileURL.path)
        }

        let rawData: Data

        do {
            rawData = try Data(contentsOf: fileURL)
        } catch {
            throw TemplateConfigurationError.unreadable(path: fileURL.path, underlying: error)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TemplaterTemplateConfiguration.self, from: rawData)
        } catch {
            throw TemplateConfigurationError.invalidJSON(path: fileURL.path, underlying: error)
        }
    }
}
