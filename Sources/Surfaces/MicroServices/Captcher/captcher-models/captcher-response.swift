import Foundation

public struct CaptcherResponse: Codable, Sendable {
    public let success: Bool
    public let token: String?
    public let type: CaptcherTokenType? 
    public let error: String?
    
    public init(
        success: Bool,
        token: String? = nil,
        type: CaptcherTokenType? = nil,
        error: String? = nil
    ) {
        self.success = success
        self.token = token
        self.type = type
        self.error = error
    }
}
