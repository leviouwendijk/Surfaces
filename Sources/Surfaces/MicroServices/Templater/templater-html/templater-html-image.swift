import Foundation
import Structures
import Interfaces
import plate

public func renderImageNode(
    placeholder:    String,
    baseURL:        URL,
    config:         TemplaterTemplateConfiguration,
    syntax:         PlaceholderSyntax,
    imageProvider:  TemplaterImageProviding
) throws -> StringTemplateReplacement {
    guard let imageSpec = config.images.first(where: { $0.placeholder == placeholder }) else {
        throw TemplaterDynamicRenderingError
          .missingProvidedValue(name: "image spec for \(placeholder)")
    }

    let data = try imageProvider.fetchImageData(at: imageSpec.path)
    let b64  = data.base64EncodedString()

    // let ext   = imageSpec.path.identifier.rawValue
    let mime  = "image/\(imageSpec.path.document.rawValue)"

    var attrs: [String:String] = [
       "src": "data:\(mime);base64,\(b64)"
    ]
    if let w = imageSpec.specifications.width {
       attrs["width"] = "\(w)"
    }
    if let h = imageSpec.specifications.height {
       attrs["height"] = "\(h)"
    }

    let node = HTMLNode(tag: "img", attributes: attrs, children: [])
    let html = node.render()

    return StringTemplateReplacement(
        placeholders:      [ syntax.set(for: placeholder) ],
        replacement:       html,
        initializer:       .manual,
        placeholderSyntax: syntax
    )
}
