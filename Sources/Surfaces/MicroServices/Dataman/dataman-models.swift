import Foundation
import Structures

public enum DatamanOperation: String, Codable, Sendable {
    case create, fetch, update, delete
}

public struct DatamanRequest: Codable, Sendable {
    public let operation: DatamanOperation
    public let database: String
    public let table: String
    public let criteria: JSONValue?
    public let values: JSONValue?
    public let fieldTypes: [String: PSQLType]?
    public let order: JSONValue?
    public let limit: Int?
    
    public init(
        operation: DatamanOperation,
        database: String,
        table: String,
        criteria: JSONValue? = nil,
        values: JSONValue? = nil,
        fieldTypes: [String: PSQLType]? = nil,
        order: JSONValue? = nil,
        limit: Int? = nil
    ) {
        self.operation = operation
        self.database = database
        self.table = table
        self.criteria = criteria
        self.values = values
        self.fieldTypes = fieldTypes
        self.order = order
        self.limit = limit
    }
}

public struct DatamanResponse: Codable, Sendable {
    public let success: Bool
    public let results: [JSONValue]?
    public let error: String?
    
    public init(success: Bool, results: [JSONValue]? = nil, error: String? = nil) {
        self.success = success
        self.results = results
        self.error = error
    }
}

