import Foundation

public struct TemplaterImageSpecifications: Codable, Sendable {
    public let width: Int?
    public let height: Int?
    
    public init(
        width: Int? = nil,
        height: Int? = nil
    ) {
        self.width = width
        self.height = height
    }
}
