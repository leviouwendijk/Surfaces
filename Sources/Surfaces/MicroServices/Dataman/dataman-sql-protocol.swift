import Foundation
import Constructors

public protocol DatamanSQLBuilding: Sendable {
    // func buildSelect(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
    // func buildInsert(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
    // func buildUpdate(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
    // func buildDelete(_ r: DatamanRequest) throws -> PSQL.RenderedSQL

    static func buildSelect(from request: DatamanRequest) throws -> PSQL.RenderedSQL
    static func buildInsert(from request: DatamanRequest) throws -> PSQL.RenderedSQL
    static func buildUpdate(from request: DatamanRequest) throws -> PSQL.RenderedSQL
    static func buildDelete(from request: DatamanRequest) throws -> PSQL.RenderedSQL
}
