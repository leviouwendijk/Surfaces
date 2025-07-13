import Foundation
import plate
import Interfaces
import Structures
import CryptoKit

public struct CaptcherValidateBody: Codable, Sendable {
    public let token: String
}

public enum CaptcherTokenType: String, Codable, Sendable {
    case new
    case reuse

    public var codename: String {
        switch self {
        case .new:
            "N"
        case .reuse:
            "RE-U"
        }
    }
}

public enum CaptcherOperation: String, Codable, Sendable {
    case fetch
    case validate
    case create
}

public struct CaptcherRequest: Codable, Sendable {
    public let operation: CaptcherOperation
    public let clientIp: String
    public let jwtToken: String?      // only for .validate
    public let rawToken: String?      // only for .create
    
    public init(
        operation: CaptcherOperation,
        clientIp: String,
        jwtToken: String? = nil,
        rawToken: String? = nil
    ) {
        self.operation = operation
        self.clientIp = clientIp
        self.jwtToken = jwtToken
        self.rawToken = rawToken
    }
}

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

extension CaptcherRequest {
    public func datamanRequest() -> DatamanRequest {
        switch operation {
        case .fetch:
            return DatamanRequest(
                operation: .fetch,
                database: "tokens",
                table: "captcha_tokens",
                criteria: .object([
                    "ip_address": .string(clientIp),
                    "invalidated": .bool(false)
                ]),
                order: .object([
                    "created_at": .string("DESC")
                ]),
                limit: 1
            )

        case .create:
            guard let raw = rawToken else {
                fatalError("Must supply rawToken for .create")
            }

            let expiryDate = Date() + (15).minutes 
            let expiry = expiryDate.postgresTimestamp
            return DatamanRequest(
                operation: .create,
                database: "tokens",
                table: "captcha_tokens",
                values: .object([
                    "hashed_token": .string(hash(raw)),
                    "expires_at":   .string(expiry),
                    "max_usages":   .int(10),
                    "ip_address":   .string(clientIp)
                ])
            )

        case .validate:
            fatalError("Validation uses JWT + DB‐side logic, not a direct DatamanRequest")
        }
    }
    
    private func hash(_ raw: String) -> String {
        let data = Data(raw.utf8)
        let digest = SHA256.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}

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
