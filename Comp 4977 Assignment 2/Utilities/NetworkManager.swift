//
//  NetworkManager.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation

///All network managers must implement a method called request, which fetches a Decodable type.
protocol NetworkManaging {
    func request<T: Decodable>(_ type: T.Type,
                                endpoint: String,
                                method: HTTPMethod,
                                body: Encodable?,
                                headers: [String: String]?) async throws -> T
}

enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
}

final class NetworkManager: NetworkManaging {
    static let shared = NetworkManager() //creates a singleton

    private let session: URLSession
    private let baseURL: URL?
    private let decoder: JSONDecoder

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

        return try decoder.decode(T.self, from: data)
    }
}

// Helper to encode Encodable without exposing concrete type
private struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init<T: Encodable>(_ wrapped: T) { _encode = wrapped.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}
