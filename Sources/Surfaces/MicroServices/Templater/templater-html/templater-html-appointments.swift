import Foundation
import plate
import Structures
import Interfaces

public struct AppointmentLocationData {
    public let address: String
    public let area:    String
}

public func htmlLocationData(
    street: String?,
    number: String?,
    area:   String?
) -> AppointmentLocationData {
    let addr: String
    if let s = street, let n = number, !s.isEmpty, !n.isEmpty {
        addr = "\(s) \(n)"
    } else if let s = street, !s.isEmpty {
        addr = s
    } else {
        addr = ""
    }
    let areaStr = (area ?? "").isEmpty ? "" : area!
    return AppointmentLocationData(address: addr, area: areaStr)
}

public func htmlAppointmentsNodes(
    navigation:       HTMLAppointmentNavigationInstructions,
    appointments:     [MailerAPIAppointmentContent],
    requestCarPlate:  Bool = false
) -> [HTMLNode] {
    guard !appointments.isEmpty else { return [] }

    var nodes: [HTMLNode] = []

    if htmlHasLocalSession(appointments: appointments) {
        let first = appointments[0]
        let loc   = htmlLocationData(
            street: first.street,
            number: first.number,
            area:   first.area
        )
        nodes += htmlNavigationInstructionsNodes(
            navigation:      navigation,
            requestCarPlate: requestCarPlate,
            location:        loc
        )
    }

    let sorted = appointments.sorted { a, b in
        let cal = Calendar.current
        guard
          let da = cal.date(from: a.dateComponents),
          let db = cal.date(from: b.dateComponents)
        else { return false }
        return da < db
    }

    for (i, appt) in sorted.enumerated() {
        if i > 0 {
            nodes.append(HTMLNode(tag:"hr"))
        }

        let loc = htmlLocationData(
            street: appt.street,
            number: appt.number,
            area:   appt.area
        )
        let topText = HTMLNode(
            tag: "p",
            attributes: ["class":"appointment-box-text"],
            children: [ HTMLNode(text:"\(appt.date)<br>\(appt.day)<br>\(appt.time)") ]
        )
        let bottomText = HTMLNode(
            tag: "p",
            attributes: ["class":"appointment-box-text-bottom"],
            children: [ HTMLNode(text:"\(appt.location)<br>\(loc.address)<br>\(loc.area)") ]
        )

        let container = HTMLNode(
            tag: "div",
            attributes: ["class":"appointment-box-container"],
            children: [topText, bottomText]
        )
        let box = HTMLNode(
            tag: "div",
            attributes: ["class":"appointment-box"],
            children: [container]
        )

        nodes.append(box)
    }

    return nodes
}
