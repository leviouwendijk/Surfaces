import Foundation
import plate
import Structures
import Interfaces

public struct HTMLTimeRange {
    public let start: String
    public let end:   String
}

public func htmlTimeRangeNodes(
    _ availability: [MailerAPIWeekday: HTMLTimeRange?],
    language: LanguageSpecifier
) -> [HTMLNode] {
    return MailerAPIWeekday.allCases.compactMap { day -> HTMLNode? in
        guard let maybeRange = availability[day],
              let range      = maybeRange,
              !range.start.isEmpty,
              !range.end.isEmpty
        else {
            return nil
        }

        let label: String
        switch language {
        case .dutch:
            label = day.dutch
        case .english:
            label = day.english
        }

        let children = HTMLBuilder.buildBlock(
            span(.class("day-label"),  "\(label):"),
            span(.class("day-hours"), "\(range.start) – \(range.end)")
        )

        return HTMLNode(
            tag: "p",
            attributes: .class("time-range-line"),
            children: children
        )
    }
}
