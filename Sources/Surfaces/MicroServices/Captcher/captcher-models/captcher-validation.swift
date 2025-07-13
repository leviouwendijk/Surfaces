import Foundation

public enum CaptcherValidationRejection: String, Codable, Sendable {
    case signatureInvalid
    case jwtExpired
    case ipMismatch
    case notFound
    case dbExpired
    case usageExceeded
    case unknown
}

public struct CaptcherValidationResult: Codable, Sendable {
    public let success: Bool
    public let reason:   CaptcherValidationRejection?

    public init(success: Bool, reason: CaptcherValidationRejection? = nil) {
        self.success = success
        self.reason   = reason
    }
}
