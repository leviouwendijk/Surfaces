import Foundation

// public enum CaptcherThresholdMetric: String, RawRepresentable, Sendable, Codable, CaseIterable {
//     case time_spent
//     case mouse_movements
//     case scroll_events
// }

public enum CaptcherSignal: String, RawRepresentable, Sendable, Codable, CaseIterable {
    case time_spent_ms
    case mouse_movements
    case scroll_events
    case keypresses
    case focus_events
    case visibility_stayed          // true if tab never backgrounded
    case pointer_types_count        // e.g., ["mouse","touch"] -> 1..3
    case max_scroll_depth_pct       // 0..100
    case first_interaction_ms       // time to first interaction
    case prefers_reduced_motion     // environment flag; usually informational
}
