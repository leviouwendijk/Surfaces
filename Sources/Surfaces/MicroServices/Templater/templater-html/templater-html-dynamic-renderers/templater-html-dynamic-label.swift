import Foundation
import plate
import Structures
import Interfaces

public func renderLabel(
    placeholder:    String,
    using provided: [String: JSONValue],
    config:         Surfaces.TemplaterTemplateConfiguration,
    syntax:         plate.PlaceholderSyntax
) throws -> plate.StringTemplateReplacement {
    // derive the label key from the placeholder name:
    // e.g. "generalized_appointment_label" → "appointment"
    let raw = placeholder
      .replacingOccurrences(of: "generalized_", with: "")
      .replacingOccurrences(of: "_label", with: "")
    guard let labelKey = Structures.GeneralizedLabel(rawValue: raw) else {
        throw TemplaterDynamicRenderingError.missingProvidedValue(name: placeholder)
    }

    // count = # of appointments
    let count = (try provided["appointments"]?.arrayValue ?? []).count

    let rep = try labelKey.replacement(
      count:      count,
      language:   config.language,
      syntax:     syntax
    )
    return rep
}
