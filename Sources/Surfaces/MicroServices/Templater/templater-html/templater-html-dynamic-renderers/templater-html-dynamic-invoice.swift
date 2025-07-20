// import Foundation
// import plate
// import Structures
// import Interfaces

////––– 3. Invoice‐LineItems renderer (sketch) –––––––––––––––––––––––––––––––––––
//func renderInvoice(
//    placeholder:    String,
//    using provided: [String: JSONValue],
//    config:         TemplaterTemplateConfiguration,
//    syntax:         PlaceholderSyntax
//) throws -> StringTemplateReplacement {
//    // pull out the raw line_items array
//    guard case let .array(rawItems)? = provided["line_items"] else {
//        throw TemplaterDynamicRenderingError.missingProvidedValue(name: "line_items")
//    }
//    let data      = try JSONEncoder().encode(rawItems)
//    let items     = try JSONDecoder().decode([InvoiceLineItem].self, from: data)

//    // build your invoice‐HTML nodes (you’ll need to write this)
//    let nodes     = htmlInvoiceLineItemsNodes(items: items)
//    let html = nodes.map { $0.render() }.joined()

//    return StringTemplateReplacement(
//        placeholders:     [syntax.set(for: placeholder)],
//        replacement:      html,
//        initializer:      .manual,
//        placeholderSyntax: syntax
//    )
//}
