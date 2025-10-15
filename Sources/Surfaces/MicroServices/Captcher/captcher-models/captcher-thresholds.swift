import Foundation

public enum CaptcherThresholdMetric: String, RawRepresentable, Sendable, Codable, CaseIterable {
    case time_spent
    case mouse_movements
    case scroll_events
}

public struct CaptcherThresholdEvaluationResult: Sendable, Codable {
    public let pass: Bool
    public let failed: [CaptcherMetricEvaluation]
    public let passed: [CaptcherMetricEvaluation]
}

public struct CaptcherMetricEvaluation: Sendable, Codable {
    public let metric: CaptcherThresholdMetric
    public let provided: Int
    public let threshold: Int 
}

public struct CaptcherMetrics: Sendable, Codable {
    public let timeSpent: Int
    public let mouseMovements: Int
    public let scrollEvents: Int
    
    public init(
        timeSpent: Int,
        mouseMovements: Int,
        scrollEvents: Int 
    ) {
        self.timeSpent = timeSpent
        self.mouseMovements = mouseMovements
        self.scrollEvents = scrollEvents
    }

    public static func thresholds(
        timeSpent: Int = 2_000,
        mouseMovements: Int = 5,
        scrollEvents: Int = 1
    ) -> Self {
        return self.init(
            timeSpent: timeSpent,
            mouseMovements: mouseMovements,
            scrollEvents: scrollEvents
        )
    }

    @inline(__always) func value(for metric: CaptcherThresholdMetric) -> Int {
        switch metric {
        case .time_spent:       return timeSpent
        case .mouse_movements:  return mouseMovements
        case .scroll_events:    return scrollEvents
        }
    }
}

public struct CaptcherThresholdEvaluator: Sendable {
    public init() {}

    public static func evaluate(
        metrics: CaptcherMetrics,
        tresholds: CaptcherMetrics = CaptcherMetrics.thresholds()
    ) -> CaptcherThresholdEvaluationResult {
        var failed: [CaptcherMetricEvaluation] = []
        var passed: [CaptcherMetricEvaluation] = []

        for metric in CaptcherThresholdMetric.allCases {
            let provided  = metrics.value(for: metric)
            let threshold = tresholds.value(for: metric)

            let item = CaptcherMetricEvaluation(
                metric: metric,
                provided: provided,
                threshold: threshold
            )

            if provided >= threshold {
                passed.append(item)
            } else {
                failed.append(item)
            }
        }

        return CaptcherThresholdEvaluationResult(
            pass: failed.isEmpty,
            failed: failed,
            passed: passed
        )
    }
}
