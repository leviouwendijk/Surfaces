import Foundation
import plate
import Commerce
import Structures
import Interfaces

public func htmlInvoiceNodes(from data: InvoiceData) -> [Interfaces.HTMLNode] {
    var nodes: [Interfaces.HTMLNode] = []

    // ── Title ──
    nodes.append(Interfaces.HTMLNode(
        tag: "p",
        attributes: ["class":"table-title"],
        children: [ Interfaces.HTMLNode(text: "Specificatie") ]
    ))

    // ── Line Items ──
    // Header row
    let headerRow = Interfaces.HTMLNode(tag: "tr", children: [
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Omschrijving") ]),
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Aantal") ]),
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Eenheidsprijs") ]),
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "BTW (%)") ]),
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Bedrag excl. BTW") ]),
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "BTW bedrag") ]),
        Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Bedrag incl. BTW") ]),
    ])

    // Item rows
    var lineRows: [Interfaces.HTMLNode] = [headerRow]
    for item in data.content {
        lineRows.append(Interfaces.HTMLNode(tag: "tr", children: [
            Interfaces.HTMLNode(tag: "td", children: [
                Interfaces.HTMLNode(text: item.parentId != nil ? "└─ \(item.name)" : item.name)
            ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["class":"col-amount","style":"text-align:center;"],
                     children: [ Interfaces.HTMLNode(text: "\(item.count)") ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["class":"col-rate","style":"text-align:right;"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.unit.net)) ]),
            Interfaces.HTMLNode(tag: "td", children: [
                Interfaces.HTMLNode(text: String(format:"%.2f%%", item.unit.vat.rate))
            ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.subtotal.net)) ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.subtotal.vat)) ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.subtotal.gross)) ]),
        ]))
    }

    // Summary row
    let summaryRow = Interfaces.HTMLNode(
        tag: "tr",
        attributes: ["class":"table-subtotal-row"],
        children: [
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["colspan":"4","class":"table-subtotal-label"],
                     children: [ Interfaces.HTMLNode(text: "Totaal") ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["class":"table-subtotal-value"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.netTotal)) ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["class":"table-subtotal-value"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.vatTotal)) ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["class":"table-subtotal-value"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.reconcilableTotal)) ]),
        ]
    )
    lineRows.append(summaryRow)

    // Wrap in table
    nodes.append(Interfaces.HTMLNode(
        tag: "table",
        attributes: ["class":"line-items-table"],
        children: lineRows
    ))

    // ── Payments ──
    if !data.payments.isEmpty {
        // Section title
        nodes.append(Interfaces.HTMLNode(
            tag: "p",
            attributes: ["class":"table-title"],
            children: [ Interfaces.HTMLNode(text: "Betalingen") ]
        ))

        // Payment rows
        var payRows: [Interfaces.HTMLNode] = []
        for pmt in data.payments {
            payRows.append(Interfaces.HTMLNode(tag: "tr", children: [
                Interfaces.HTMLNode(tag: "td", children: [ Interfaces.HTMLNode(text: pmt.details) ]),
                Interfaces.HTMLNode(tag: "td",
                         attributes: ["style":"text-align:right;"],
                         children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", pmt.amount)) ]),
            ]))
        }

        // Payment summary
        payRows.append(Interfaces.HTMLNode(
            tag: "tr",
            attributes: ["class":"table-subtotal-row"],
            children: [
                Interfaces.HTMLNode(tag: "td",
                         attributes: ["class":"table-subtotal-label"],
                         children: [ Interfaces.HTMLNode(text: "Totaal voldane betalingen") ]),
                Interfaces.HTMLNode(tag: "td",
                         attributes: ["class":"table-subtotal-value"],
                         children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.paymentTotal)) ]),
            ]
        ))

        // Wrap in table
        nodes.append(Interfaces.HTMLNode(
            tag: "table",
            attributes: ["class":"payments-table"],
            children: payRows
        ))
    }

    // ── Final Overview ──
    nodes.append(Interfaces.HTMLNode(
        tag: "p",
        attributes: ["class":"table-title"],
        children: [ Interfaces.HTMLNode(text: "Samenvatting") ]
    ))

    var overviewRows: [Interfaces.HTMLNode] = []
    // Net total (excl. BTW)
    overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
        Interfaces.HTMLNode(tag: "td",
                 attributes: ["style":"font-weight:500;"],
                 children: [ Interfaces.HTMLNode(text: "Som excl. BTW") ]),
        Interfaces.HTMLNode(tag: "td",
                 attributes: ["style":"text-align:right;"],
                 children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.netTotal)) ]),
    ]))

    // Gross total (incl. BTW)
    overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
                Interfaces.HTMLNode(tag: "td",
                    attributes: ["style":"font-weight:500;"],
                    children: [ Interfaces.HTMLNode(text: "Som leverbare goederen en diensten") ]),
                Interfaces.HTMLNode(tag: "td",
                    attributes: ["style":"text-align:right;"],
                    children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.reconcilableTotal)) ]),
    ]))
    // Payments total (if any)
    if !data.payments.isEmpty {
        overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["style":"font-weight:500;"],
                     children: [ Interfaces.HTMLNode(text: "Reeds voldane betalingen") ]),
            Interfaces.HTMLNode(tag: "td",
                     attributes: ["style":"text-align:right;"],
                     children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.paymentTotal)) ]),
        ]))
    }
    // Final balance
    let label = data.finalBalance.payableOrReceivable().overviewLabel()
    overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
        Interfaces.HTMLNode(tag: "td",
                 attributes: ["style":"font-weight:700;"],
                 children: [ Interfaces.HTMLNode(text: label) ]),
        Interfaces.HTMLNode(tag: "td",
                 attributes: ["style":"text-align:right;font-weight:700;"],
                 children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.finalBalance)) ]),
    ]))

    nodes.append(Interfaces.HTMLNode(
        tag: "table",
        attributes: ["class":"final-overview-table"],
        children: overviewRows
    ))

    return nodes
}
