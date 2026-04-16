import Foundation
import plate
// import Extensions
import Primitives

public enum DatabaseKey: String, CaseIterable, StringParsableEnum {
    case tokens
    case leads
    case analytics
}
