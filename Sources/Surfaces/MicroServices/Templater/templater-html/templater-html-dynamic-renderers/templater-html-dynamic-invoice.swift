import Foundation
import plate
import Structures
import Interfaces
import Commerce

// helper for decoding payments
private struct InvoicePaymentConfig: Decodable {
    let details: String
    let amount: Double
}

public func renderInvoice(
    placeholder: String,
    using provided: [String: JSONValue],
    config: Surfaces.TemplaterTemplateConfiguration,
    syntax: plate.PlaceholderSyntax
) throws -> plate.StringTemplateReplacement {
    guard case let .array(rawLineItems)? = provided["line_items"] else {
        throw TemplaterDynamicRenderingError.missingProvidedValue(name: "line_items")
    }
    let lineItemsData = try JSONEncoder().encode(rawLineItems)
    let items = try JSONDecoder().decode([InvoiceLineItem].self, from: lineItemsData)

    let payments: [InvoicePayment]
    if case let .array(rawPayments)? = provided["payments"] {
        let paymentsData = try JSONEncoder().encode(rawPayments)
        let cfgs = try JSONDecoder().decode([InvoicePaymentConfig].self, from: paymentsData)
        payments = cfgs.map { InvoicePayment(details: $0.details, amount: $0.amount) }
    } else {
        payments = []
    }

    guard case let .object(detailsObj)? = config.defaults?["details"] else {
        throw TemplaterDynamicRenderingError.missingProvidedValue(name: "details")
    }
    let detailsData = try JSONEncoder().encode(JSONValue.object(detailsObj))
    let details = try JSONDecoder().decode(InvoiceDetails.self, from: detailsData)

    let id: Int
    if case let .string(idStr)? = provided["id"], let parsed = Int(idStr) {
        id = parsed
    } else {
        id = 0
    }

    let invoice = InvoiceData(
        id:       id,
        details:  details,
        content:  items,
        payments: payments
    )

    let nodes = htmlInvoiceNodes(from: invoice)
    // let html  = nodes.map { $0.render() }.joined()
    let html  = nodes.map { $0.render(pretty: false, indent: 0, indentStep: 2) }.joined()

    return plate.StringTemplateReplacement(
        placeholders:      [syntax.set(for: placeholder)],
        replacement:       html,
        initializer:       .manual,
        placeholderSyntax: syntax
    )
}
