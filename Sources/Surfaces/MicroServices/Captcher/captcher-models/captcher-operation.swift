import Foundation
// import Extensions
import plate

public enum CaptcherOperation: String, Codable, Sendable, StringParsableEnum {
    case fetch
    case validate
    case create
}
