import Foundation
import plate
import Structures
import Structures
import CryptoKit

public struct CaptcherRequest: Codable, Sendable {
    public let operation: CaptcherOperation
    public let clientIp: String
    public let jwtToken: String?      // only for .validate
    public let rawToken: String?      // only for .create
    public let fieldTypes: [String: PSQLType]?
    
    public init(
        operation: CaptcherOperation,
        clientIp: String,
        jwtToken: String? = nil,
        rawToken: String? = nil,
        fieldTypes: [String: PSQLType]? = nil
    ) {
        self.operation = operation
        self.clientIp = clientIp
        self.jwtToken = jwtToken
        self.rawToken = rawToken
        self.fieldTypes = fieldTypes
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
                fieldTypes: [
                    "id":           .uuid,
                    "hashed_token": .text,
                    "expires_at":   .timestamptz,
                    "usage_count":  .integer,
                    "max_usages":   .integer,
                    "created_at":   .timestamptz
                ],
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
                ]),
                fieldTypes: [
                    "hashed_token": .text,
                    "expires_at":   .timestamptz,
                    "max_usages":   .integer,
                    "ip_address":   .text
                ]
            )

        case .validate:
            fatalError("Validation uses JWT + DB‐side logic, not a direct DatamanRequest")
        }
    }
}
