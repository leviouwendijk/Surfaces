import Foundation
import Extensions

public enum CaptcherOperation: String, Codable, Sendable, StringParsableEnum {
    case fetch
    case validate
    case create
}
