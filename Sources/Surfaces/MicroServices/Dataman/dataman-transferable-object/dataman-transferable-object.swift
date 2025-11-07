import Foundation
import Structures
import Constructors

public protocol DatamanTransferableObject {
    associatedtype Row: Decodable & Sendable
    associatedtype CreatePayload: Encodable & Sendable = Void
    associatedtype UpdatePayload: Encodable & Sendable = Void

    static var database: String { get }
    static var table: String { get }

    static var psqlTypeInferenceStrategy: PSQLTypeInferenceStrategy<Row> { get }
    static func psqlTypes() throws -> [String: PSQLType]

    static var defaultOrder: JSONValue? { get }
    static var defaultLimit: Int? { get }

    /// Centralized encoding/decoding & per-payload transforms
    static var coding: DatamanCoding { get }

    // Convenience hooks (usually not overridden)
    static func decodeRow(from j: JSONValue) throws -> Row
    static func encodeCreatePayload(_ p: CreatePayload) throws -> [String: JSONValue]
    static func encodeUpdatePayload(_ p: UpdatePayload) throws -> [String: JSONValue]
}

public extension DatamanTransferableObject {
    static func psqlTypes() throws -> [String: PSQLType] {
        try psqlTypeInferenceStrategy.resolve()
    }

    /// Default coding preset: snake_case + ISO8601
    static var coding: DatamanCoding { DatamanCodingPresets.snakeISO8601() }

    static func decodeRow(from j: JSONValue) throws -> Row {
        try coding.decoder.decode(Row.self, from: JSONEncoder().encode(j))
    }

    static func encodeCreatePayload(_ p: CreatePayload) throws -> [String: JSONValue] {
        try JSONValueCodec.encodeObject(p, using: coding.encoder, transform: coding.createTransform)
    }

    static func encodeUpdatePayload(_ p: UpdatePayload) throws -> [String: JSONValue] {
        try JSONValueCodec.encodeObject(p, using: coding.encoder, transform: coding.updateTransform)
    }
}
