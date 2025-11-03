import Foundation

public enum CaptcherDecision: String, RawRepresentable, PreparedContent {
    case pass
    case allowFlag
    case challenge
}
