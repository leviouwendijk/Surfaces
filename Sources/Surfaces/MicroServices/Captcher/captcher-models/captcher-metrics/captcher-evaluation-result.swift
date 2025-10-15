import Foundation

public struct CaptcherSignalContribution: Sendable, Codable {
    public let signal: CaptcherSignal
    public let contributed: Int   // positive, zero, or negative
    public let observed: String   // compact human-readable note (for logs)
}

public struct CaptcherRiskEvaluationResult: Sendable, Codable {
    public let decision: CaptcherDecision
    public let score: Int
    public let contributions: [CaptcherSignalContribution]
    public let notes: [String]    // freeform context (e.g., “reduced-motion: true”)
}
