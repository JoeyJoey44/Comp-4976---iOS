//
//  NetworkManager.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation

/// Protocol describing a networking client capable of performing typed requests.
///
/// Implementations should return a decoded `Decodable` type or throw an error. The
/// app uses a singleton `NetworkManager.shared` which conforms to this protocol; however,
/// the protocol is useful for test doubles or alternative implementations.
protocol NetworkManaging {
    /// Perform a network request and decode the response into `T`.
    ///
    /// - Parameters:
    ///   - type: The expected `Decodable` response type.
    ///   - endpoint: The endpoint path or absolute URL string.
    ///   - method: HTTP method to use for the request.
    ///   - body: Optional request body (any `Encodable`).
    ///   - headers: Optional additional headers.
    func request<T: Decodable>(_ type: T.Type,
                                endpoint: String,
                                method: HTTPMethod,
                                body: Encodable?,
                                headers: [String: String]?) async throws -> T
}

/// Common HTTP methods used by the network layer.
enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

/// Errors produced by the `NetworkManager`.
enum NetworkError: Error {
    /// The provided endpoint could not be converted to a valid URL.
    case invalidURL
    /// The response from `URLSession` was not an HTTP response.
    case invalidResponse
    /// Non-2xx HTTP status code. Contains the status code and raw response data.
    case httpError(statusCode: Int, data: Data)
}

/// A lightweight networking client used across the app.
///
/// Responsibilities:
/// - Build URLRequests using the app `Config` base URL when available.
/// - Attach a Bearer token from `Utils.getToken()` when present.
/// - Encode request bodies from arbitrary `Encodable` values.
/// - Decode responses using `Utils.robustDecoder()` to tolerate multiple date formats.
final class NetworkManager: NetworkManaging {
    /// Shared singleton instance used by view models.
    static let shared = NetworkManager()

    private let session: URLSession
    private let baseURL: URL?
    private let decoder: JSONDecoder

    /// Create a NetworkManager.
    /// - Parameters:
    ///   - session: URLSession instance (useful to inject mocks in tests).
    ///   - baseURLString: Optional base URL string; when provided `endpoint` may be a
    ///     relative path.
    init(session: URLSession = .shared, baseURLString: String? = Config.baseURL) {
        self.session = session
        if let s = baseURLString { self.baseURL = URL(string: s) } else { self.baseURL = nil }
        self.decoder = Utils.robustDecoder()
    }

    func request<T: Decodable>(_ type: T.Type,
                                endpoint: String,
                                method: HTTPMethod = .get,
                                body: Encodable? = nil,
                                headers: [String: String]? = nil) async throws -> T
    {
        // Build URL
        let url: URL
        if let base = baseURL {
            guard let u = URL(string: endpoint, relativeTo: base) else { throw NetworkError.invalidURL }
            url = u
        } else {
            guard let u = URL(string: endpoint) else { throw NetworkError.invalidURL }
            url = u
        }
        
        // Build URL request
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Attach token if available
        if let token = Utils.getToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Additional headers
        if let hdrs = headers {
            for (k, v) in hdrs { req.setValue(v, forHTTPHeaderField: k) }
        }

        // Encode body
        if let b = body {
            req.httpBody = try JSONEncoder().encode(AnyEncodable(b))
        }

        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }

        if !(200...299).contains(http.statusCode) {
            throw NetworkError.httpError(statusCode: http.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // If the caller expects a plain String but the server returned raw text
            // (not a JSON string), decoding into String via JSONDecoder will fail.
            // As a convenience, fallback to returning the UTF-8 string when T == String.
            if T.self == String.self, let s = String(data: data, encoding: .utf8) as? T {
                return s
            }
            throw error
        }
    }
}

// Helper to encode Encodable without exposing concrete type
private struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init<T: Encodable>(_ wrapped: T) { _encode = wrapped.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}
