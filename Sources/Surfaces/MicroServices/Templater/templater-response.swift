import Foundation

public struct TemplaterRenderResponse: Codable, Sendable {
    public let success: Bool
    public let subject: String?
    public let use: [TemplaterUseDesignation]?
    public let text: String?
    public let html: String?
    public let base64: String?
    public let error: String?
    
    public init(
        success: Bool,
        subject: String?,
        use: [TemplaterUseDesignation]?,
        text: String?,
        html: String?,
        base64: String?,
        error: String?
    ) {
        self.success = success
        self.subject = subject
        self.use = use
        self.text = text
        self.html = html
        self.base64 = base64
        self.error = error
    }
}
