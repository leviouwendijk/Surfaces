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
    public static func rawPosix(_ fmt: DateFormatter) -> DatamanCoding {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .formatted(fmt)

        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .formatted(fmt)

        return DatamanCoding(encoder: enc, decoder: dec)
    }

    /// raw keys (no case conversion) + ISO8601 dates
    public static func rawISO8601() -> DatamanCoding {
        let enc = JSONEncoder()
        if #available(macOS 13, iOS 16, *) {
            enc.dateEncodingStrategy = .iso8601
        }

        let dec = JSONDecoder()
        if #available(macOS 13, iOS 16, *) {
            dec.dateDecodingStrategy = .iso8601
        }

        return DatamanCoding(encoder: enc, decoder: dec)
    }

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

    // /// snake_case keys + PostgreSQL-style formatter you already use
    // /// (replace with your concrete shared formatter)
    // public static func snakePostgres(_ fmt: DateFormatter = StandardDateFormatter.postgres) -> DatamanCoding {
    //     snakePosix(dateFormatter: fmt)
    // }

    public static func snakePostgresISO8601(
        _ fmt: ISO8601DateFormatter = {
            let f = ISO8601DateFormatter()
            // f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return f
        }()
    ) -> DatamanCoding {
        let opts = fmt.formatOptions
        let tz   = fmt.timeZone

        @Sendable
        func makeFmt() -> ISO8601DateFormatter {
            let f = ISO8601DateFormatter()
            f.formatOptions = opts
            f.timeZone = tz
            return f
        }

        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .convertToSnakeCase
        enc.dateEncodingStrategy = .custom { date, encoder in
            var c = encoder.singleValueContainer()
            let f = makeFmt()
            try c.encode(f.string(from: date))
        }

        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        dec.dateDecodingStrategy = .custom { decoder in
            let c = try decoder.singleValueContainer()
            let s = try c.decode(String.self)
            let f = makeFmt()
            if let d = f.date(from: s) { return d }
            throw DecodingError.dataCorrupted(.init(
                codingPath: decoder.codingPath,
                debugDescription: "Invalid ISO8601 date: \(s)"
            ))
        }

        return DatamanCoding(encoder: enc, decoder: dec)
    }
}
