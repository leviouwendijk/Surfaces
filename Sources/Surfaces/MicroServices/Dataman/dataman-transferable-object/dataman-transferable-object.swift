import Foundation
import Structures
import Constructors

public protocol DatamanTransferableObject {
    associatedtype Row: Decodable & Sendable

    static var database: String { get }
    static var table: String { get }
    static func fieldTypes() async throws -> [String: PSQLType]

    static var defaultOrder: JSONValue? { get }
    static var defaultLimit: Int? { get }
}

public extension DatamanTransferableObject {
    static func overridingDecoder() -> JSONDecoder { JSONDecoder() }
    static func decodeRow(from j: JSONValue) throws -> Row {
        try overridingDecoder().decode(Row.self, from: JSONEncoder().encode(j))
    }
}
