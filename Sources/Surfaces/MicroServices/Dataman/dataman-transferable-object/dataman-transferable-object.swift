import Foundation
import Structures
import Constructors

public protocol DatamanTransferableObject {
    associatedtype Row: Decodable & Sendable

    static var database: String { get }
    static var table: String { get }

    /// Declare how PSQL types are obtained.
    static var psqlTypeInferenceStrategy: PSQLTypeInferenceStrategy<Row> { get }

    /// Final PSQL type map for this DTO (auto from strategy).
    static func psqlTypes() throws -> [String: PSQLType]

    static var defaultOrder: JSONValue? { get }
    static var defaultLimit: Int? { get }

    // Decoding
    static func overridingDecoder() -> JSONDecoder
    static func decodeRow(from j: JSONValue) throws -> Row
}

public extension DatamanTransferableObject {
    static func overridingDecoder() -> JSONDecoder { JSONDecoder() }

    static func decodeRow(from j: JSONValue) throws -> Row {
        try overridingDecoder().decode(Row.self, from: JSONEncoder().encode(j))
    }

    /// Default: resolve via the declared strategy.
    static func psqlTypes() throws -> [String: PSQLType] {
        try psqlTypeInferenceStrategy.resolve()
    }
}
