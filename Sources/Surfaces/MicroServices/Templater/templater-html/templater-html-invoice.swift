import Foundation
import plate
import Commerce
import Structures
import Interfaces
import Constructors

// public func htmlInvoiceNodes(from data: InvoiceData) -> [Interfaces.HTMLNode] {
public func htmlInvoiceNodes(from data: InvoiceData) -> HTMLFragment {
    // var nodes: [Interfaces.HTMLNode] = []
    var nodes: HTMLFragment = []

    // nodes.append(Interfaces.HTMLNode(
    //     tag: "p",
    //     attributes: ["class":"table-title"],
    //     children: [ Interfaces.HTMLNode(text: "Specificatie") ]
    // ))
    nodes.append(HTML.p(.class(["table-title"])) { "Specificatie" })

    // let headerRow = Interfaces.HTMLNode(tag: "tr", children: [
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Omschrijving") ]),
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Aantal") ]),
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Eenheidsprijs") ]),
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "BTW (%)") ]),
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Bedrag excl. BTW") ]),
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "BTW bedrag") ]),
    //     Interfaces.HTMLNode(tag: "th", children: [ Interfaces.HTMLNode(text: "Bedrag incl. BTW") ]),
    // ])
    let headerRow: any Constructors.HTMLNode = HTML.tr {
        HTML.th { "Omschrijving" }
        HTML.th { "Aantal" }
        HTML.th { "Eenheidsprijs" }
        HTML.th { "BTW (%)" }
        HTML.th { "Bedrag excl. BTW" }
        HTML.th { "BTW bedrag" }
        HTML.th { "Bedrag incl. BTW" }
    }

    // var lineRows: [Interfaces.HTMLNode] = [headerRow]
    // for item in data.content {
    //     lineRows.append(Interfaces.HTMLNode(tag: "tr", children: [
    //         Interfaces.HTMLNode(tag: "td", children: [
    //             Interfaces.HTMLNode(text: item.parentId != nil ? "└─ \(item.name)" : item.name)
    //         ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["class":"col-amount","style":"text-align:center;"],
    //                  children: [ Interfaces.HTMLNode(text: "\(item.count)") ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["class":"col-rate","style":"text-align:right;"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.unit.net)) ]),
    //         Interfaces.HTMLNode(tag: "td", children: [
    //             Interfaces.HTMLNode(text: String(format:"%.2f%%", item.unit.vat.rate))
    //         ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["style":"text-align:right;"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.subtotal.net)) ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["style":"text-align:right;"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.subtotal.vat)) ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["style":"text-align:right;"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", item.subtotal.gross)) ]),
    //     ]))
    // }
    var lineRows: HTMLFragment = [headerRow]
    for item in data.content {
        lineRows.append(
            HTML.tr {
                HTML.td { item.parentId != nil ? "└─ \(item.name)" : item.name }
                // HTML.td(.class(["col-amount"]), ["style":"text-align:center;"]) { "\(item.count)" }
                // HTML.td(.class(["col-rate"]),   ["style":"text-align:right;"]) { String(format:"€%.2f", item.unit.net) }
                HTML.td(["class":"col-amount", "style":"text-align:center;"]) { "\(item.count)" }
                HTML.td(["class":"col-rate", "style":"text-align:right;"])   { String(format:"€%.2f", item.unit.net) }
                HTML.td { String(format:"%.2f%%", item.unit.vat.rate) }
                HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", item.subtotal.net) }
                HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", item.subtotal.vat) }
                HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", item.subtotal.gross) }
            }
        )
    }

    // let summaryRow = Interfaces.HTMLNode(
    //     tag: "tr",
    //     attributes: ["class":"table-subtotal-row"],
    //     children: [
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["colspan":"4","class":"table-subtotal-label"],
    //                  children: [ Interfaces.HTMLNode(text: "Totaal") ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["class":"table-subtotal-value"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.netTotal)) ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["class":"table-subtotal-value"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.vatTotal)) ]),
    //         Interfaces.HTMLNode(tag: "td",
    //                  attributes: ["class":"table-subtotal-value"],
    //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.reconcilableTotal)) ]),
    //     ]
    // )
    // lineRows.append(summaryRow)
    let summaryRow: any Constructors.HTMLNode = HTML.tr(.class(["table-subtotal-row"])) {
        HTML.td(["colspan":"4", "class":"table-subtotal-label"]) { "Totaal" }
        HTML.td(.class(["table-subtotal-value"])) { String(format:"€%.2f", data.netTotal) }
        HTML.td(.class(["table-subtotal-value"])) { String(format:"€%.2f", data.vatTotal) }
        HTML.td(.class(["table-subtotal-value"])) { String(format:"€%.2f", data.reconcilableTotal) }
    }
    lineRows.append(summaryRow)

    // nodes.append(Interfaces.HTMLNode(
    //     tag: "table",
    //     attributes: ["class":"line-items-table"],
    //     children: lineRows
    // ))
    nodes.append(HTML.table(.class(["line-items-table"])) { lineRows })

    // ── Payments ──
    if !data.payments.isEmpty {
        // nodes.append(Interfaces.HTMLNode(
        //     tag: "p",
        //     attributes: ["class":"table-title"],
        //     children: [ Interfaces.HTMLNode(text: "Betalingen") ]
        // ))
        nodes.append(HTML.p(.class(["table-title"])) { "Betalingen" })

        // var payRows: [Interfaces.HTMLNode] = []
        // for pmt in data.payments {
        //     payRows.append(Interfaces.HTMLNode(tag: "tr", children: [
        //         Interfaces.HTMLNode(tag: "td", children: [ Interfaces.HTMLNode(text: pmt.details) ]),
        //         Interfaces.HTMLNode(tag: "td",
        //                  attributes: ["style":"text-align:right;"],
        //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", pmt.amount)) ]),
        //     ]))
        // }
        var payRows: HTMLFragment = []
        for pmt in data.payments {
            payRows.append(
                HTML.tr {
                    HTML.td { pmt.details }
                    HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", pmt.amount) }
                }
            )
        }

        // payRows.append(Interfaces.HTMLNode(
        //     tag: "tr",
        //     attributes: ["class":"table-subtotal-row"],
        //     children: [
        //         Interfaces.HTMLNode(tag: "td",
        //                  attributes: ["class":"table-subtotal-label"],
        //                  children: [ Interfaces.HTMLNode(text: "Totaal voldane betalingen") ]),
        //         Interfaces.HTMLNode(tag: "td",
        //                  attributes: ["class":"table-subtotal-value"],
        //                  children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.paymentTotal)) ]),
        //     ]
        // ))
        payRows.append(
            HTML.tr(.class(["table-subtotal-row"])) {
                HTML.td(.class(["table-subtotal-label"])) { "Totaal voldane betalingen" }
                HTML.td(.class(["table-subtotal-value"])) { String(format:"€%.2f", data.paymentTotal) }
            }
        )

        // nodes.append(Interfaces.HTMLNode(
        //     tag: "table",
        //     attributes: ["class":"payments-table"],
        //     children: payRows
        // ))
        nodes.append(HTML.table(.class(["payments-table"])) { payRows })
    }

    // nodes.append(Interfaces.HTMLNode(
    //     tag: "p",
    //     attributes: ["class":"table-title"],
    //     children: [ Interfaces.HTMLNode(text: "Samenvatting") ]
    // ))
    nodes.append(HTML.p(.class(["table-title"])) { "Samenvatting" })

    // var overviewRows: [Interfaces.HTMLNode] = []
    var overviewRows: HTMLFragment = []
    // Net total (excl. BTW)
    // overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
    //     Interfaces.HTMLNode(tag: "td",
    //              attributes: ["style":"font-weight:500;"],
    //              children: [ Interfaces.HTMLNode(text: "Som excl. BTW") ]),
    //     Interfaces.HTMLNode(tag: "td",
    //              attributes: ["style":"text-align:right;"],
    //              children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.netTotal)) ]),
    // ]))
    overviewRows.append(
        HTML.tr {
            HTML.td(["style":"font-weight:500;"]) { "Som excl. BTW" }
            HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", data.netTotal) }
        }
    )

    // Gross total (incl. BTW)
    // overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
    //             Interfaces.HTMLNode(tag: "td",
    //                 attributes: ["style":"font-weight:500;"],
    //                 children: [ Interfaces.HTMLNode(text: "Som leverbare goederen en diensten") ]),
    //             Interfaces.HTMLNode(tag: "td",
    //                 attributes: ["style":"text-align:right;"],
    //                 children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.reconcilableTotal)) ]),
    // ]))
    overviewRows.append(
        HTML.tr {
            HTML.td(["style":"font-weight:500;"]) { "Som leverbare goederen en diensten" }
            HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", data.reconcilableTotal) }
        }
    )

    // Payments total (if any)
    if !data.payments.isEmpty {
        // overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
        //     Interfaces.HTMLNode(tag: "td",
        //              attributes: ["style":"font-weight:500;"],
        //              children: [ Interfaces.HTMLNode(text: "Reeds voldane betalingen") ]),
        //     Interfaces.HTMLNode(tag: "td",
        //              attributes: ["style":"text-align:right;"],
        //              children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.paymentTotal)) ]),
        // ]))

        overviewRows.append(
            HTML.tr {
                HTML.td(["style":"font-weight:500;"]) { "Reeds voldane betalingen" }
                HTML.td(["style":"text-align:right;"]) { String(format:"€%.2f", data.paymentTotal) }
            }
        )
    }

    // Final balance
    let label = data.finalBalance.payableOrReceivable().overviewLabel()
    // overviewRows.append(Interfaces.HTMLNode(tag: "tr", children: [
    //     Interfaces.HTMLNode(tag: "td",
    //              attributes: ["style":"font-weight:700;"],
    //              children: [ Interfaces.HTMLNode(text: label) ]),
    //     Interfaces.HTMLNode(tag: "td",
    //              attributes: ["style":"text-align:right;font-weight:700;"],
    //              children: [ Interfaces.HTMLNode(text: String(format:"€%.2f", data.finalBalance)) ]),
    // ]))
    overviewRows.append(
        HTML.tr {
            HTML.td(["style":"font-weight:700;"]) { label }
            HTML.td(["style":"text-align:right;font-weight:700;"]) { String(format:"€%.2f", data.finalBalance) }
        }
    )

    // nodes.append(Interfaces.HTMLNode(
    //     tag: "table",
    //     attributes: ["class":"final-overview-table"],
    //     children: overviewRows
    // ))
    nodes.append(HTML.table(.class(["final-overview-table"])) { overviewRows })

    return nodes
}
