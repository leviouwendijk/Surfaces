import Foundation

public struct RenderedSQL: Sendable {
    public let sql: String
    public let binds: [SQLBind]
    public init(_ sql: String, _ binds: [SQLBind]) {
        self.sql = sql
        self.binds = binds
    }
}

public protocol DatamanSQLBuilding: Sendable {
    func buildSelect(_ r: DatamanRequest) throws -> RenderedSQL
    func buildInsert(_ r: DatamanRequest) throws -> RenderedSQL
    func buildUpdate(_ r: DatamanRequest) throws -> RenderedSQL
    func buildDelete(_ r: DatamanRequest) throws -> RenderedSQL
}

public enum SQLBind: Sendable, Equatable {
    case null
    case bool(Bool)
    case int(Int)
    case int64(Int64)
    case double(Double)
    case string(String)
    case data(Data)

    public static func from<T>(_ value: T?) -> SQLBind where T: Sendable {
        guard let v = value else { return .null }
        switch v {
        case let x as Bool:   return .bool(x)
        case let x as Int:    return .int(x)
        case let x as Int64:  return .int64(x)
        case let x as Double: return .double(x)
        case let x as String: return .string(x)
        case let x as Data:   return .data(x)
        default:
            if let encodable = v as? Encodable,
               let data = try? JSONEncoder().encode(AnyEncodable(encodable)) {
                return .data(data)
            }
            return .string(String(describing: v))
        }
    }
}

public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<E: Encodable>(_ e: E) { _encode = e.encode }
    public func encode(to encoder: Encoder) throws { try _encode(encoder) }
}
