import Foundation
import Extensions

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
