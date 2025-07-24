import Foundation
import plate
import Structures

public enum TemplaterPlaceholderConstructor: String, Codable, Sendable {
    case appointments
    case label
    case invoice
    case time_range

    public func render(
        placeholder: String,
        using provided: [String: JSONValue],
        config: TemplaterTemplateConfiguration,
        syntax: PlaceholderSyntax
    ) throws -> StringTemplateReplacement {
        switch self {
            case .appointments:
                return try renderAppointments(placeholder: placeholder, using: provided, config: config, syntax: syntax)
            case .label:
                return try renderLabel(placeholder: placeholder, using: provided, config: config, syntax: syntax)
            case .invoice:
                return try renderInvoice(placeholder: placeholder, using: provided, config: config, syntax: syntax)
            case .time_range:
                return try renderTimeRange(placeholder: placeholder, using: provided, config: config, syntax: syntax)
        }
    }
}
