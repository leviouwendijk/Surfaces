import Foundation

public enum AnalyzerEventType: String, Codable, Sendable {
    case pageview
    case engaged_time
    case heat_click
    case form_start
    case form_step_view
    case form_validation_error
    case form_submit
    case form_step_next
    case form_step_back
    case env
    case cta_click
    case address_lookup
}

public struct AnalyzerEventDTO: Codable, Sendable {
    public let type: AnalyzerEventType
    
    // public var domain: String?     // e.g. "hondenmeesters.nl"
    public var subdomain: String?  // e.g. "docs" or "root"
    public var location: String?   // e.g. "/contact" (path only, no query/fragment)

    // optional fields (present depending on type)
    public var url: String?
    public var ref: String?
    public var title: String?
    public var lang: String?
    public var ua: String?
    public var vp_w: Int?
    public var vp_h: Int?
    public var ms: Int?
    public var x: Double?
    public var y: Double?
    public var el: String?
    public var id: String?       // form_id
    public var step: String?     // form_step
    public var tz: String?
    public var dpr: Double?
    public var ok: Bool?         // for captcha/validation states

    public init(type: AnalyzerEventType) { self.type = type }
}

public struct AnalyzerCollectEnvelope: Codable, Sendable {
    public let site_id: String
    public let ts: Int64              // ms epoch
    public let visitor_id: String?
    public let session_id: String
    public let events: [AnalyzerEventDTO]
}
