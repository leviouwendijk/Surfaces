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
    navigation:        Surfaces.HTMLAppointmentNavigationInstructions,
    requestCarPlate:   Bool = false,
    location:          Surfaces.AppointmentLocationData?
) -> [Interfaces.HTMLNode] {
    // Icon container
    let iconNode = Interfaces.HTMLNode(
        tag: "div",
        attributes: ["class":"nav-instructions__icon"],
        children: [ Interfaces.HTMLNode(text: HTMLStandardAssets.navigationIcon) ]
    )

    // Intro paragraph
    let introNode = Interfaces.HTMLNode(
        tag: "p",
        attributes: ["class":"nav-instructions__intro"],
        children: [ Interfaces.HTMLNode(text: navigation.intro) ]
    )

    var addressNodes: [Interfaces.HTMLNode] = []
    addressNodes.append(
        Interfaces.HTMLNode(
          tag: "p",
          attributes: ["class":"nav-instructions__address"],
          children: [ Interfaces.HTMLNode(text: navigation.location)]
        )
    )

    // Detail paragraph
    let detailNode = Interfaces.HTMLNode(
        tag: "p",
        attributes: ["class":"nav-instructions__detail"],
        children: [ Interfaces.HTMLNode(text: navigation.detail) ]
    )

    // Optional request paragraph
    var requestNodes: [Interfaces.HTMLNode] = []
    if requestCarPlate, let req = navigation.request {
        requestNodes.append(
            Interfaces.HTMLNode(
              tag: "p",
              attributes: ["class":"nav-instructions__text"],
              children: [ Interfaces.HTMLNode(text: req) ]
            )
        )
    }

    // Wrap inner content
    let innerDiv = Interfaces.HTMLNode(
        tag: "div",
        children: [introNode] + addressNodes + [detailNode] + requestNodes
    )

    // Root nav container
    let root = Interfaces.HTMLNode(
        tag: "div",
        attributes: ["class":"nav-instructions"],
        children: [iconNode, innerDiv]
    )

    return [root]
}
