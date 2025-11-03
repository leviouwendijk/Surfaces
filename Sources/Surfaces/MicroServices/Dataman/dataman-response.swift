import Foundation
import Structures
import Extensions

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
