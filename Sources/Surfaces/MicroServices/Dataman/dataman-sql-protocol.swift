import Foundation
import Constructors

public protocol DatamanSQLBuilding: Sendable {
    func buildSelect(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
    func buildInsert(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
    func buildUpdate(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
    func buildDelete(_ r: DatamanRequest) throws -> PSQL.RenderedSQL
}
