import Foundation
import plate

public enum CaptcherDecision: String, RawRepresentable, Sendable, Codable {
    case pass
    case allowFlag
    case challenge
}
