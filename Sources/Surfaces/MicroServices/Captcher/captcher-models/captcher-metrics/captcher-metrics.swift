import Foundation

public struct CaptcherMetrics: Sendable, Codable {
    public let timeSpent: Int                  // ms
    public let mouseMovements: Int
    public let scrollEvents: Int
    public let keypresses: Int
    public let focusEvents: Int
    public let visibilityStayed: Bool
    public let pointerTypes: [String]          // ["mouse","touch","pen"]
    public let maxScrollDepthPct: Int          // 0..100
    public let firstInteractionAt: Int?        // ms since load (optional)
    public let prefersReducedMotion: Bool

    public init(
        timeSpent: Int,
        mouseMovements: Int,
        scrollEvents: Int,
        keypresses: Int,
        focusEvents: Int, 
        visibilityStayed: Bool,
        pointerTypes: [String],
        maxScrollDepthPct: Int,
        firstInteractionAt: Int?,
        prefersReducedMotion: Bool 
    ) {
        self.timeSpent = timeSpent
        self.mouseMovements = mouseMovements
        self.scrollEvents = scrollEvents
        self.keypresses = keypresses
        self.focusEvents = focusEvents
        self.visibilityStayed = visibilityStayed
        self.pointerTypes = pointerTypes
        self.maxScrollDepthPct = maxScrollDepthPct
        self.firstInteractionAt = firstInteractionAt
        self.prefersReducedMotion = prefersReducedMotion
    }

    // public static func thresholds(
    //     timeSpent: Int = 2_000,
    //     mouseMovements: Int = 5,
    //     scrollEvents: Int = 1
    // ) -> Self {
    //     .init(timeSpent: timeSpent, mouseMovements: mouseMovements, scrollEvents: scrollEvents)
    // }
}

