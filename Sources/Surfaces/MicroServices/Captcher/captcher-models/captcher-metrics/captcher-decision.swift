import Foundation
import plate

public enum CaptcherDecision: String, RawRepresentable, PreparableContent {
    case pass
    case allowFlag
    case challenge
}
