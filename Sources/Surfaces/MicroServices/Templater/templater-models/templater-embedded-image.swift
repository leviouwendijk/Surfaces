import Foundation
import plate
import Extensions

public enum TemplaterImageWidthSettingError: Error, LocalizedError, Sendable {
    case noWidthAvailableForFile(String)

    public var errorDescription: String? {
        switch self {
        case .noWidthAvailableForFile(let file):
            return "No width available for tried file: \(file)"
        }
    }
}

public enum TemplaterImageWidthSetting: String, RawRepresentable, Sendable, StringParsableEnum {
    case hondenmeesters
    case h_logo
    case ideal

    public var typed: String {
        switch self {
        case .hondenmeesters:
            return rawValue + DocumentExtensionType.png.dotPrefixed

        case .h_logo:
            return rawValue.underscoresToHyphens() + DocumentExtensionType.png.dotPrefixed

        case .ideal:
            return rawValue + DocumentExtensionType.png.dotPrefixed
        }
    }

    public func width() throws -> Int {
        switch self {
        case .hondenmeesters:
            return 200

        case .h_logo:
            return 50

        default:
            throw TemplaterImageWidthSettingError.noWidthAvailableForFile(self.typed)
        }
    }
}

public func embedImages(
    in html: String,
    imageDir: URL,
    widths: [String: Int]? = nil
) -> String {
    let pattern = #"<img\s+src=\"([^\"]+)\"([^>]*)>"#
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
        return html
    }

    let nsHTML = html as NSString
    var result = html
    let matches = regex.matches(
        in: html,
        options: [],
        range: NSRange(location: 0, length: nsHTML.length)
    )

    for match in matches.reversed() {
        let fullRange  = match.range(at: 0)
        let srcRange   = match.range(at: 1)
        let attrsRange = match.range(at: 2)

        let imageSrc = nsHTML.substring(with: srcRange)
        let attrs    = nsHTML.substring(with: attrsRange)
        let imageName = (imageSrc as NSString).lastPathComponent
        let imgURL    = imageDir.appendingPathComponent(imageName)


        guard let data = try? Data(contentsOf: imgURL) else {
            continue
        }

        let ext   = imgURL.pathExtension.lowercased()
        let mime = ext == "jpg" ? "image/jpeg" : "image/\(ext)"
        let b64   = data.base64EncodedString()

        let widthAttribute: String
        do {
            let setting = try TemplaterImageWidthSetting.parse(from: imageName)
            let width =  try setting.width()
            widthAttribute = " width=\"\(width)\""
        } catch {
            widthAttribute = ""
        }

        let cleaned = attrs.strippingHtmlWidthAttributes()

        let replacement = #"<img src="data:\#(mime);base64,\#(b64)"\#(widthAttribute) \#(cleaned)>"#
        result = (result as NSString).replacingCharacters(in: fullRange, with: replacement)
    }
    return result
}
