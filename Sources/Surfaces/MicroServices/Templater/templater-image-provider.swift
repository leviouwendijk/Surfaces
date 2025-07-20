import Foundation
import plate

public enum TemplaterImageError: Error, LocalizedError, Sendable {
    case notFound(path: String)
    case unreadable(path: String, underlying: Error)

    public var errorDescription: String? {
        switch self {
        case let .notFound(path):
            return "Image file not found at path: \(path)"
        case let .unreadable(path, underlying):
            return "Couldn’t read image at \(path): \(underlying.localizedDescription)"
        }
    }
}

public protocol TemplaterImageProviding: Sendable {
    func fetchImageData(at imagePath: TemplaterImagePath) throws -> Data
}

public struct TemplaterImageProvider: TemplaterImageProviding, Sendable {
    public let baseURL: URL

    // private static let candidateExtensions: [DocumentExtensionType] = [
    //     .png, .jpg, .jpeg
    // ]

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func fetchImageData(
        at imagePath: TemplaterImagePath
    ) throws -> Data {
        let fm = FileManager.default
        // let basePath = imagePath.basePath

        // for ext in Self.candidateExtensions {
        //     let fileName = basePath + ext.dotPrefixed
        //     let fileURL  = baseURL.appendingPathComponent(fileName)

        //     if fm.fileExists(atPath: fileURL.path) {
        //         do {
        //             return try Data(contentsOf: fileURL)
        //         } catch {
        //             throw TemplaterImageError.unreadable(path: fileURL.path, underlying: error)
        //         }
        //     }
        // }

        let fileName = imagePath.extendedPath
        let fileURL  = baseURL.appendingPathComponent(fileName)

        if fm.fileExists(atPath: fileURL.path) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw TemplaterImageError.unreadable(path: fileURL.path, underlying: error)
            }
        }

        // let tried = Self.candidateExtensions.map { ".\($0)" }.joined(separator: ", ")
        let tried = imagePath.document.rawValue
        let missingPath = baseURL.appendingPathComponent(imagePath.basePath).path
        throw TemplaterImageError.notFound(path: "\(missingPath)(\(tried))")
    }
}
