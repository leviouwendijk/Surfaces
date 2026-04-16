import Foundation
// import Extensions
import plate
import Primitives

public enum CaptcherOperation: String, Codable, Sendable, StringParsableEnum {
    case fetch
    case validate
    case create
}
