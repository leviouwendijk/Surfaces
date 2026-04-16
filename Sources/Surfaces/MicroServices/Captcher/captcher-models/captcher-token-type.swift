import Foundation
// import Extensions
import plate
import Primitives

public enum CaptcherTokenType: String, Codable, Sendable, StringParsableEnum {
    case new
    case reuse

    public var codename: String {
        switch self {
        case .new:
            "N"
        case .reuse:
            "RE-U"
        }
    }
}
