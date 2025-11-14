//
//  Utils.swift
//  Comp 4977 Assignment 2
//
//  Reusable helpers for view models: network request helpers, robust JSON decoder,
//  token storage helpers, and debug utilities.
//

import Foundation

/// Reusable helpers used across view models and network code.
///
/// This struct contains small, focused helpers that the app relies on, such as token
/// persistence wrappers (which delegate to the keychain manager), a robust JSON decoder
/// tolerant to multiple date formats, and debug helpers for pretty-printing JSON and
/// masking tokens.
struct Utils {

    // MARK: - Token helpers
    /// Persist (or remove) the JWT token in the Keychain.
    /// - Parameter token: Token string to save. If `nil` the token will be removed.
    static func saveToken(_ token: String?) {
        // Persist token securely in Keychain
        KeychainTokenManager.saveToken(token)
    }

    /// Retrieve the stored token from Keychain, if present.
    /// - Returns: The token string or `nil` when missing.
    static func getToken() -> String? {
        KeychainTokenManager.getToken()
    }

    /// Remove the token from Keychain.
    static func removeToken() {
        KeychainTokenManager.removeToken()
    }

    // MARK: - Robust JSON decoder (handles ISO8601 with microseconds, numeric epochs, and common formats)
    /// Create a JSONDecoder configured to tolerate a variety of date formats.
    ///
    /// The returned decoder will successfully decode dates expressed as:
    /// - Numeric epoch timestamps (seconds or milliseconds),
    /// - ISO8601 with fractional seconds, and common RFC/posix formats.
    /// - Strings containing numeric timestamps such as `/Date(1234567890)/`.
    ///
    /// Use this decoder for API responses where the date format may vary between endpoints
    /// or servers.
    /// - Returns: A configured `JSONDecoder` instance.
    static func robustDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()

            // Try numeric representations first
            if let doubleValue = try? container.decode(Double.self) {
                // If large, treat as seconds since epoch; if extremely large treat as ms
                if doubleValue > 1_000_000_000_000 { return Date(timeIntervalSince1970: doubleValue/1000.0) }
                return Date(timeIntervalSince1970: doubleValue)
            }
            if let intValue = try? container.decode(Int64.self) {
                let v = Double(intValue)
                if v > 1_000_000_000_000 { return Date(timeIntervalSince1970: v/1000.0) }
                return Date(timeIntervalSince1970: v)
            }

            // Otherwise parse as string
            let dateString = try container.decode(String.self)

            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = iso.date(from: dateString) { return d }

            iso.formatOptions = [.withInternetDateTime]
            if let d = iso.date(from: dateString) { return d }

            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            let formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss.SSSZ", "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss"]
            for fmt in formats {
                df.dateFormat = fmt
                if let d = df.date(from: dateString) { return d }
            }

            // Try to extract large numeric timestamp from string like /Date(1234567890)/
            if let regex = try? NSRegularExpression(pattern: "\\d+", options: []) {
                let range = NSRange(location: 0, length: dateString.utf16.count)
                if let match = regex.firstMatch(in: dateString, options: [], range: range) {
                    if let matchRange = Range(match.range, in: dateString) {
                        let numberString = String(dateString[matchRange])
                        if let ms = Double(numberString) {
                            if ms > 1_000_000_000_000 { return Date(timeIntervalSince1970: ms/1000.0) }
                            if ms > 1_000_000_000 { return Date(timeIntervalSince1970: ms) }
                        }
                    }
                }
            }

            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode date string: \(dateString)"))
        }
        return decoder
    }

    /// Pretty-print JSON `Data` for logs and debugging.
    ///
    /// - Parameter data: Raw JSON `Data`.
    /// - Returns: A pretty-printed JSON `String` when possible, otherwise a best-effort UTF-8 string or a placeholder.
    static func prettyJSON(_ data: Data) -> String {
        if let obj = try? JSONSerialization.jsonObject(with: data, options: []),
           let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted]),
           let s = String(data: pretty, encoding: .utf8) {
            return s
        }
        return String(data: data, encoding: .utf8) ?? "<non-utf8 data>"
    }

    /// Return a masked representation of a JWT-like token, hiding sensitive sections.
    /// - Parameter token: The token string to mask.
    /// - Returns: A short masked representation suitable for logs (e.g. "<redacted>.xyz").
    static func maskedToken(_ token: String?) -> String {
        guard let t = token else { return "<nil>" }
        let parts = t.split(separator: ".")
        if parts.count >= 2 {
            return "<redacted>." + String(parts.last ?? "")
        }
        return "<redacted>"
    }
}
