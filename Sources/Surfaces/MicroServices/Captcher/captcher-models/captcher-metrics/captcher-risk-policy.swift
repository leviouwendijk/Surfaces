import Foundation

public struct CaptcherRiskPolicy: Sendable, Codable {
    public var timeSpentMsMin: Int = 800
    public var minMouseMoves: Int = 1
    public var minScrollEvents: Int = 1
    public var minKeyOrFocus: Int = 1
    public var minDepthPct: Int = 10

    public var weightTime: Int = 1
    public var weightMoves: Int = 1
    public var weightScroll: Int = 1
    public var weightKeyOrFocus: Int = 1
    public var weightVisibilityStayed: Int = 1
    public var weightPointerTypes: Int = 1
    public var weightDepth: Int = 1

    /// soft negative for “robotic” patterns (all zero + ultra fast)
    public var penalizeUltraFastAllZero: Bool = true
    public var ultraFastMs: Int = 300
    public var penaltyUltraFast: Int = -1

    /// Accessibility guard: if true, we won't *require* movement for users with reduced motion.
    public var skipMotionWhenReduced: Bool = true

    /// Decision bands
    public var minScorePass: Int = 3
    public var minScoreAllowFlag: Int = 1

    public init() {}
}
