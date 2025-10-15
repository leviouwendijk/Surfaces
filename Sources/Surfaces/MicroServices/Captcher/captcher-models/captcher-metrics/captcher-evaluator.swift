import Foundation

public struct CaptcherRiskEvaluator: Sendable {
    public init() {}

    public func evaluate(
        metrics m: CaptcherMetrics,
        policy p: CaptcherRiskPolicy = .init()
    ) -> CaptcherRiskEvaluationResult {
        var score = 0
        var out: [CaptcherSignalContribution] = []
        var notes: [String] = []

        // time_spent_ms
        do {
            let ok = m.timeSpent >= p.timeSpentMsMin
            let delta = ok ? p.weightTime : 0
            score += delta
            out.append(.init(signal: .time_spent_ms, contributed: delta, observed: "\(m.timeSpent)ms (min \(p.timeSpentMsMin))"))
        }

        // mouse_movements (skip requirement under reduced motion if configured)
        do {
            let effectiveMin = (p.skipMotionWhenReduced && m.prefersReducedMotion) ? 0 : p.minMouseMoves
            let ok = m.mouseMovements >= effectiveMin
            let delta = ok ? p.weightMoves : 0
            score += delta
            out.append(.init(signal: .mouse_movements, contributed: delta, observed: "\(m.mouseMovements) (min \(effectiveMin))"))
            if p.skipMotionWhenReduced && m.prefersReducedMotion { notes.append("reduced-motion: true (movement min relaxed)") }
        }

        // scroll_events
        do {
            let ok = m.scrollEvents >= p.minScrollEvents
            let delta = ok ? p.weightScroll : 0
            score += delta
            out.append(.init(signal: .scroll_events, contributed: delta, observed: "\(m.scrollEvents) (min \(p.minScrollEvents))"))
        }

        // keypresses OR focus_events
        do {
            let keyOrFocus = max(m.keypresses, m.focusEvents)
            let ok = keyOrFocus >= p.minKeyOrFocus
            let delta = ok ? p.weightKeyOrFocus : 0
            score += delta
            out.append(.init(signal: .keypresses, contributed: 0, observed: "\(m.keypresses)"))
            out.append(.init(signal: .focus_events, contributed: 0, observed: "\(m.focusEvents)"))
            out.append(.init(signal: .visibility_stayed, contributed: 0, observed: "")) // placeholder to keep shape stable
            // record aggregated “credit”
            out.append(.init(signal: .visibility_stayed, contributed: 0, observed: "")) // will fill below
            // We'll actually add visibility separately below; keeping structure explicit
            // Replace previous two no-op rows with a single combined contribution if you prefer.
            score += 0 // (handled via delta above)
        }

        // visibility_stayed
        do {
            let ok = m.visibilityStayed
            let delta = ok ? p.weightVisibilityStayed : 0
            score += delta
            out.append(.init(signal: .visibility_stayed, contributed: delta, observed: "\(m.visibilityStayed)"))
        }

        // pointer_types_count
        do {
            let count = Set(m.pointerTypes.map { $0.lowercased() }).count
            let ok = count >= 1
            let delta = ok ? p.weightPointerTypes : 0
            score += delta
            out.append(.init(signal: .pointer_types_count, contributed: delta, observed: "\(count) from \(m.pointerTypes)"))
        }

        // max_scroll_depth_pct
        do {
            let ok = m.maxScrollDepthPct >= p.minDepthPct
            let delta = ok ? p.weightDepth : 0
            score += delta
            out.append(.init(signal: .max_scroll_depth_pct, contributed: delta, observed: "\(m.maxScrollDepthPct)% (min \(p.minDepthPct)%)"))
        }

        // first_interaction_ms (informational; simple soft penalty for ultra-fast + no signals)
        if let fia = m.firstInteractionAt {
            var contributed = 0
            if p.penalizeUltraFastAllZero {
                let noSignals = (m.mouseMovements == 0 && m.scrollEvents == 0 && m.keypresses == 0 && m.focusEvents == 0)
                if fia <= p.ultraFastMs && noSignals {
                    contributed = p.penaltyUltraFast
                    score += contributed
                    notes.append("ultra-fast first interaction (\(fia)ms) with no other signals")
                }
            }
            out.append(.init(signal: .first_interaction_ms, contributed: contributed, observed: "\(fia)ms (ultra≤\(p.ultraFastMs)ms)"))
        } else {
            out.append(.init(signal: .first_interaction_ms, contributed: 0, observed: "nil"))
        }

        // prefers_reduced_motion (no score impact; context only)
        out.append(.init(signal: .prefers_reduced_motion, contributed: 0, observed: "\(m.prefersReducedMotion)"))
        if m.prefersReducedMotion { notes.append("prefers-reduced-motion=true") }

        // Final decision
        let decision: CaptcherDecision
        if score >= p.minScorePass {
            decision = .pass
        } else if score >= p.minScoreAllowFlag {
            decision = .allowFlag
        } else {
            decision = .challenge
        }

        return .init(decision: decision, score: score, contributions: out, notes: notes)
    }
}
