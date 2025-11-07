import Structures
import Constructors

public enum DatamanTransferableObjectQuery<D: DatamanTransferableObject> {
    public static func fetch(
        criteria: JSONValue,
        order: JSONValue? = D.defaultOrder,
        limit: Int? = D.defaultLimit
    ) async throws -> DatamanRequest {
        DatamanRequest(
            operation: .fetch,
            database:  D.database,
            table:     D.table,
            criteria:  criteria,
            values:    nil,
            fieldTypes: try D.psqlTypes(),
            order:     order,
            limit:     limit
        )
    }

    public static func create(values: [String: JSONValue]) async throws -> DatamanRequest {
        DatamanRequest(
            operation: .create,
            database:  D.database,
            table:     D.table,
            criteria:  nil,
            values:    .object(values),
            fieldTypes: try D.psqlTypes()
        )
    }


    public static func create(_ payload: D.CreatePayload) async throws -> DatamanRequest {
        let values = try D.encodeCreatePayload(payload)
        return DatamanRequest(
            operation: .create,
            database:  D.database,
            table:     D.table,
            criteria:  nil,
            values:    .object(values),
            fieldTypes: try D.psqlTypes(),
            order:     nil,
            limit:     nil
        )
    }

    public static func update(
        criteria: JSONValue,
        values: [String: JSONValue]
    ) async throws -> DatamanRequest {
        DatamanRequest(
            operation: .update,
            database:  D.database,
            table:     D.table,
            criteria:  criteria,
            values:    .object(values),
            fieldTypes: try D.psqlTypes()
        )
    }

    public static func update(criteria: JSONValue, payload: D.UpdatePayload) async throws -> DatamanRequest {
        let values = try D.encodeUpdatePayload(payload)
        return DatamanRequest(
            operation: .update,
            database:  D.database,
            table:     D.table,
            criteria:  criteria,
            values:    .object(values),
            fieldTypes: try D.psqlTypes(),
            order:     nil,
            limit:     nil
        )
    }

    public static func delete(criteria: JSONValue) async throws -> DatamanRequest {
        DatamanRequest(
            operation: .delete,
            database:  D.database,
            table:     D.table,
            criteria:  criteria,
            values:    nil,
            fieldTypes: try D.psqlTypes()
        )
    }
}
