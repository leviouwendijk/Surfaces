import Foundation

public struct TokensTokenRow {
    public let id: UUID
    public let hashed: String
    public let expiresAt: Date
    public let usageCount: Int
    public let maxUsages: Int
    
    public init(
        id: UUID,
        hashed: String,
        expiresAt: Date,
        usageCount: Int,
        maxUsages: Int
    ) {
        self.id = id
        self.hashed = hashed
        self.expiresAt = expiresAt
        self.usageCount = usageCount
        self.maxUsages = maxUsages
    }
}
