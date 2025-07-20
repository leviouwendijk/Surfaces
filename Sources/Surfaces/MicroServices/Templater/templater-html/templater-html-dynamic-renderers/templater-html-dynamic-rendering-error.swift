import Foundation

public enum TemplaterDynamicRenderingError: Error, LocalizedError, Sendable {
    case missingProvidedValue(name: String)

    public var errorDescription: String? {
        switch self {
        case .missingProvidedValue(let name):
            return "Missing provided value from template's config json, required to construct a dynamically rendered variable: \(name)"
        }
    }
}
