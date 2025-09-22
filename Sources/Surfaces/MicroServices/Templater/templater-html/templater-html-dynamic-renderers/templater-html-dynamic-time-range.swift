import Foundation
import plate
import Structures
import Interfaces

public func renderTimeRange(
    placeholder:    String,
    using provided: [String: JSONValue],
    config:         Surfaces.TemplaterTemplateConfiguration,
    syntax:         plate.PlaceholderSyntax
) throws -> plate.StringTemplateReplacement {
    // pull out the time_range object
    guard case let .object(obj)? = provided["time_range"] else {
        throw TemplaterDynamicRenderingError.missingProvidedValue(name: "time_range")
    }
    let data         = try JSONEncoder().encode(JSONValue.object(obj))
    let availability = try JSONDecoder()
    .decode([Structures.MailerAPIWeekday: Surfaces.HTMLTimeRange].self, from: data)

    // build and render
    let nodes = htmlTimeRangeNodes(availability, language: config.language)
    let html = nodes.map { $0.render() }.joined()

    return plate.StringTemplateReplacement(
        placeholders:     [syntax.set(for: placeholder)],
        replacement:      html,
        initializer:      .manual,
        placeholderSyntax: syntax
    )
}
