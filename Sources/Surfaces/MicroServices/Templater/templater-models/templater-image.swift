import Foundation

public struct TemplaterImage: Codable, Sendable {
    public let placeholder: String
    public let path: TemplaterImagePath
    public let specifications: TemplaterImageSpecifications
    
    public init(
        placeholder: String,
        path: TemplaterImagePath,
        specifications: TemplaterImageSpecifications
    ) {
        self.placeholder = placeholder
        self.path = path
        self.specifications = specifications
    }
}
