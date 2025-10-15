import Foundation

public enum CaptcherDecision: String, RawRepresentable, Sendable, Codable {
    case pass
    case allowFlag
    case challenge
}
