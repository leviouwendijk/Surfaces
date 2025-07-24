import Foundation
import plate
import Commerce
import Structures
import Interfaces

public func htmlInvoiceNodes(from data: InvoiceData) -> [HTMLNode] {
    var nodes: [HTMLNode] = []

    // ── Title ──
    nodes.append(HTMLNode(
        tag: "p",
        attributes: ["class":"table-title"],
        children: [ HTMLNode(text: "Specificatie") ]
    ))

    // ── Line Items ──
    // Header row
    let headerRow = HTMLNode(tag: "tr", children: [
        HTMLNode(tag: "th", children: [ HTMLNode(text: "Omschrijving") ]),
        HTMLNode(tag: "th", children: [ HTMLNode(text: "Aantal") ]),
        HTMLNode(tag: "th", children: [ HTMLNode(text: "Eenheidsprijs (excl. BTW)") ]),
        HTMLNode(tag: "th", children: [ HTMLNode(text: "BTW (%)") ]),
        HTMLNode(tag: "th", children: [ HTMLNode(text: "Totaal excl. BTW") ]),
        HTMLNode(tag: "th", children: [ HTMLNode(text: "BTW bedrag") ]),
        HTMLNode(tag: "th", children: [ HTMLNode(text: "Totaal incl. BTW") ]),
    ])

    // Item rows
    var lineRows: [HTMLNode] = [headerRow]
    for item in data.content {
        lineRows.append(HTMLNode(tag: "tr", children: [
            HTMLNode(tag: "td", children: [
                HTMLNode(text: item.parentId != nil ? "└─ \(item.name)" : item.name)
            ]),
            HTMLNode(tag: "td",
                     attributes: ["class":"col-amount","style":"text-align:center;"],
                     children: [ HTMLNode(text: "\(item.count)") ]),
            HTMLNode(tag: "td",
                     attributes: ["class":"col-rate","style":"text-align:right;"],
                     children: [ HTMLNode(text: String(format:"€%.2f", item.unit.net)) ]),
            HTMLNode(tag: "td", children: [
                HTMLNode(text: String(format:"%.2f%%", item.unit.vat.rate))
            ]),
            HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ HTMLNode(text: String(format:"€%.2f", item.subtotal.net)) ]),
            HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ HTMLNode(text: String(format:"€%.2f", item.subtotal.vat)) ]),
            HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ HTMLNode(text: String(format:"€%.2f", item.subtotal.gross)) ]),
        ]))
    }

    // Summary row
    let summaryRow = HTMLNode(
        tag: "tr",
        attributes: ["class":"table-subtotal-row"],
        children: [
            HTMLNode(tag: "td",
                     attributes: ["colspan":"4","class":"table-subtotal-label"],
                     children: [ HTMLNode(text: "Totaal") ]),
            HTMLNode(tag: "td",
                     attributes: ["class":"table-subtotal-value"],
                     children: [ HTMLNode(text: String(format:"€%.2f", data.netTotal)) ]),
            HTMLNode(tag: "td",
                     attributes: ["class":"table-subtotal-value"],
                     children: [ HTMLNode(text: String(format:"€%.2f", data.vatTotal)) ]),
            HTMLNode(tag: "td",
                     attributes: ["class":"table-subtotal-value"],
                     children: [ HTMLNode(text: String(format:"€%.2f", data.reconcilableTotal)) ]),
        ]
    )
    lineRows.append(summaryRow)

    // Wrap in table
    nodes.append(HTMLNode(
        tag: "table",
        attributes: ["class":"line-items-table"],
        children: lineRows
    ))

    // ── Payments ──
    if !data.payments.isEmpty {
        // Section title
        nodes.append(HTMLNode(
            tag: "p",
            attributes: ["class":"table-title"],
            children: [ HTMLNode(text: "Betalingen") ]
        ))

        // Payment rows
        var payRows: [HTMLNode] = []
        for pmt in data.payments {
            payRows.append(HTMLNode(tag: "tr", children: [
                HTMLNode(tag: "td", children: [ HTMLNode(text: pmt.details) ]),
                HTMLNode(tag: "td",
                         attributes: ["style":"text-align:right;"],
                         children: [ HTMLNode(text: String(format:"€%.2f", pmt.amount)) ]),
            ]))
        }

        // Payment summary
        payRows.append(HTMLNode(
            tag: "tr",
            attributes: ["class":"table-subtotal-row"],
            children: [
                HTMLNode(tag: "td",
                         attributes: ["class":"table-subtotal-label"],
                         children: [ HTMLNode(text: "Totaal voldane betalingen") ]),
                HTMLNode(tag: "td",
                         attributes: ["class":"table-subtotal-value"],
                         children: [ HTMLNode(text: String(format:"€%.2f", data.paymentTotal)) ]),
            ]
        ))

        // Wrap in table
        nodes.append(HTMLNode(
            tag: "table",
            attributes: ["class":"payments-table"],
            children: payRows
        ))
    }

    // ── Final Overview ──
    nodes.append(HTMLNode(
        tag: "p",
        attributes: ["class":"table-title"],
        children: [ HTMLNode(text: "Samenvatting") ]
    ))

    var overviewRows: [HTMLNode] = []
    // Net total
    overviewRows.append(HTMLNode(tag: "tr", children: [
        HTMLNode(tag: "td",
                 attributes: ["style":"font-weight:500;"],
                 children: [ HTMLNode(text: "Som leverbare goederen en diensten") ]),
        HTMLNode(tag: "td",
                 attributes: ["style":"text-align:right;"],
                 children: [ HTMLNode(text: String(format:"€%.2f", data.netTotal)) ]),
    ]))
    // Payments total (if any)
    if !data.payments.isEmpty {
        overviewRows.append(HTMLNode(tag: "tr", children: [
            HTMLNode(tag: "td",
                     attributes: ["style":"font-weight:500;"],
                     children: [ HTMLNode(text: "Reeds voldane betalingen") ]),
            HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ HTMLNode(text: String(format:"€%.2f", data.paymentTotal)) ]),
        ]))
    }
    // Final balance
    let label = data.finalBalance.payableOrReceivable().overviewLabel()
    overviewRows.append(HTMLNode(tag: "tr", children: [
        HTMLNode(tag: "td",
                 attributes: ["style":"font-weight:700;"],
                 children: [ HTMLNode(text: label) ]),
        HTMLNode(tag: "td",
                 attributes: ["style":"text-align:right;font-weight:700;"],
                 children: [ HTMLNode(text: String(format:"€%.2f", data.finalBalance)) ]),
    ]))

    nodes.append(HTMLNode(
        tag: "table",
        attributes: ["class":"final-overview-table"],
        children: overviewRows
    ))

    return nodes
}
