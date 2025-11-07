import Foundation
import Structures

public struct DatamanCoding {
    public var encoder: JSONEncoder
    public var decoder: JSONDecoder
    /// Optional transforms applied when turning payloads into [String: JSONValue]
    public var createTransform: JSONValueTransform
    public var updateTransform: JSONValueTransform

    public init(
        encoder: JSONEncoder,
        decoder: JSONDecoder,
        createTransform: JSONValueTransform = .init(),
        updateTransform: JSONValueTransform = .init()
    ) {
        self.encoder = encoder
        self.decoder = decoder
        self.createTransform = createTransform
        self.updateTransform = updateTransform
    }
}

public enum DatamanCodingPresets {
    /// Snake_case keys, ISO8601 dates (safe default)
    public static func snakeISO8601() -> DatamanCoding {
        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .convertToSnakeCase
        if #available(macOS 13, iOS 16, *) {
            enc.dateEncodingStrategy = .iso8601
        }

        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        if #available(macOS 13, iOS 16, *) {
            dec.dateDecodingStrategy = .iso8601
        }

        return DatamanCoding(encoder: enc, decoder: dec)
    }

    /// POSIX/formatter based (explicit)
    public static func snakePosix(dateFormatter: DateFormatter) -> DatamanCoding {
        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .convertToSnakeCase
        enc.dateEncodingStrategy = .formatted(dateFormatter)

        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        dec.dateDecodingStrategy = .formatted(dateFormatter)

        return DatamanCoding(encoder: enc, decoder: dec)
    }
}
