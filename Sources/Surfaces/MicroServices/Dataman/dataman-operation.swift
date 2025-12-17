import Foundation
import plate
// import Structures
// import Extensions

public enum DatamanOperation: String, Codable, Sendable, StringParsableEnum {
    case create, fetch, update, delete
}
