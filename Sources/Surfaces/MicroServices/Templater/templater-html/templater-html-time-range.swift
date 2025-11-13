import Foundation
import plate
import Structures
import Interfaces
import Constructors

public struct HTMLTimeRange: Sendable, Codable {
    public let start: String
    public let end:   String
    
    public init(
        start: String,
        end: String
    ) {
        self.start = start
        self.end = end
    }
}

public func htmlTimeRangeNodes(
    _ availability: [MailerAPIWeekday: Surfaces.HTMLTimeRange?],
    language: plate.LanguageSpecifier
// ) -> [Interfaces.HTMLNode] {
) -> HTMLFragment {
    // return MailerAPIWeekday.allCases.compactMap { day -> Interfaces.HTMLNode? in
    return MailerAPIWeekday.allCases.compactMap { day -> (any Constructors.HTMLNode)? in
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
        default:
            label = "<unsupported language error>"
        }

        // let children = Interfaces.HTMLBuilder.buildBlock(
        //     span(.class("day-label"),  "\(label):"),
        //     span(.class("day-hours"), "\(range.start) – \(range.end)")
        // )

        // return Interfaces.HTMLNode(
        //     tag: "p",
        //     attributes: .class("time-range-line"),
        //     children: children
        // )
        return HTML.p(.class(["time-range-line"])) {
            HTML.span(.class(["day-label"]))  { "\(label):" }
            HTML.span(.class(["day-hours"])) { "\(range.start) – \(range.end)" }
        }
    }
}
