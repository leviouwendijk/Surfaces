import Foundation
import plate
import Structures
import Interfaces
import Constructors

public func renderAppointments(
    placeholder:    String,
    using provided: [String: JSONValue],
    config:         Surfaces.TemplaterTemplateConfiguration,
    syntax:         plate.PlaceholderSyntax
) throws -> StringTemplateReplacement {
    // 1a) appointments array
    guard case let .array(rawArr)? = provided["appointments"] else {
        throw TemplaterDynamicRenderingError.missingProvidedValue(name: "appointments")
    }
    let data     = try JSONEncoder().encode(rawArr)
    let appts    = try JSONDecoder().decode([MailerAPIAppointmentContent].self, from: data)

    // 1b) request_car_plate flag
    let requestCarPlate = (try? provided["request_car_plate"]?.boolValue) ?? false

    // 1c) navigation defaults
    guard case let .object(navObj)? = config.defaults?["navigation"] else {
        throw TemplaterDynamicRenderingError.missingProvidedValue(name: "navigation")
    }
    let navData  = try JSONEncoder().encode(JSONValue.object(navObj))
    let navModel = try JSONDecoder().decode(Surfaces.HTMLAppointmentNavigationInstructions.self, from: navData)

    // 1d) build the nodes and render to HTML
    let nodes    = Surfaces.htmlAppointmentsNodes(
        navigation:      navModel,
        appointments:    appts,
        requestCarPlate: requestCarPlate
    )
    // let html = nodes.map { $0.render() }.joined()
    let html = nodes.map { $0.render(pretty: false, indent: 0, indentStep: 2) }.joined()

    // 1e) wrap in a replacement
    return plate.StringTemplateReplacement(
        placeholders:     [syntax.set(for: placeholder)],
        replacement:      html,
        initializer:      .manual,
        placeholderSyntax: syntax
    )
}

