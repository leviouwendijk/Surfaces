import Foundation

public enum DatamanService {
    public static func handle(
        _ request: DatamanRequest,
        executor: DatamanDatabaseExecutor
    ) async throws -> DatamanResponse {
        return try await executor.execute(request: request)
    }
}
