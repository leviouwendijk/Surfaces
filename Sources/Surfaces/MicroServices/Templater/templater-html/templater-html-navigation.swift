import Foundation
import plate
import Structures
import Interfaces

public struct HTMLAppointmentNavigationInstructions: Codable, Sendable {
    public let intro:    String
    public let location: String
    public let detail:   String
    public let request:  String?
    
    public init(
        intro:    String,
        location: String,
        detail:   String,
        request:  String? = nil
    ) {
        self.intro    = intro
        self.location = location
        self.detail   = detail
        self.request  = request
    }
}

public func htmlHasLocalSession(
    appointments: [MailerAPIAppointmentContent]
) -> Bool {
    let patterns = [
        "Prins\\s*Hendrikstraat",
        "Wilhelminalaan",
        "Harddraverslaan",
        "Alkmaarderhout"
    ].compactMap { try? NSRegularExpression(pattern: $0, options: [.caseInsensitive]) }

    return appointments.contains { appt in
        let street = appt.street
        guard !street.isEmpty else { return false }
        let range = NSRange(location: 0, length: street.utf16.count)
        return patterns.contains { regex in
            regex.firstMatch(in: street, options: [], range: range) != nil
        }
    }
}

public func htmlNavigationInstructionsNodes(
    navigation:        HTMLAppointmentNavigationInstructions,
    requestCarPlate:   Bool = false,
    location:          AppointmentLocationData?
) -> [HTMLNode] {
    // Icon container
    let iconNode = HTMLNode(
        tag: "div",
        attributes: ["class":"nav-instructions__icon"],
        children: [ HTMLNode(text: HTMLStandardAssets.navigationIcon) ]
    )

    // Intro paragraph
    let introNode = HTMLNode(
        tag: "p",
        attributes: ["class":"nav-instructions__intro"],
        children: [ HTMLNode(text: navigation.intro) ]
    )

    var addressNodes: [HTMLNode] = []
    addressNodes.append(
        HTMLNode(
          tag: "p",
          attributes: ["class":"nav-instructions__address"],
          children: [ HTMLNode(text: navigation.location)]
        )
    )

    // Detail paragraph
    let detailNode = HTMLNode(
        tag: "p",
        attributes: ["class":"nav-instructions__detail"],
        children: [ HTMLNode(text: navigation.detail) ]
    )

    // Optional request paragraph
    var requestNodes: [HTMLNode] = []
    if requestCarPlate, let req = navigation.request {
        requestNodes.append(
            HTMLNode(
              tag: "p",
              attributes: ["class":"nav-instructions__text"],
              children: [ HTMLNode(text: req) ]
            )
        )
    }

    // Wrap inner content
    let innerDiv = HTMLNode(
        tag: "div",
        children: [introNode] + addressNodes + [detailNode] + requestNodes
    )

    // Root nav container
    let root = HTMLNode(
        tag: "div",
        attributes: ["class":"nav-instructions"],
        children: [iconNode, innerDiv]
    )

    return [root]
}
