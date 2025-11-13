//
//  LoginViewViewModel.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation
import Combine

@MainActor
class LoginViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var loggedInUser: User? = nil
    @Published var token: String? = nil

    func login() async {
        errorMessage = ""
        isLoading = true
        print("[LoginViewViewModel] login() started for email: \(email)")
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            isLoading = false
            return
        }

        let loginPayload = [
            "email": email,
            "password": password
        ]

        guard let url = URL(string: "\(APIConfig.baseURL)/api/Auth/login") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginPayload)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Raw response for debugging
            if let raw = String(data: data, encoding: .utf8) {
                print("[LoginViewViewModel] raw response JSON: \n\(raw)")
            } else {
                print("[LoginViewViewModel] raw response: <non-utf8 data>")
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid server response."
                isLoading = false
                return
            }

            if httpResponse.statusCode != 200 {
                let serverError = String(data: data, encoding: .utf8) ?? "Unknown error"
                errorMessage = "Login failed: \(serverError)"
                print("[LoginViewViewModel] login failed status: \(httpResponse.statusCode) - \(serverError)")
                isLoading = false
                return
            }

            let decoder = JSONDecoder()
            // Robust date decoding: try ISO8601 (with/without fractional seconds), common formats,
            // numeric epoch (seconds or milliseconds), and /Date(123...)/ style.
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let container = try decoder.singleValueContainer()

                // 1) If server encoded as a number (seconds since epoch)
                if let doubleValue = try? container.decode(Double.self) {
                    return Date(timeIntervalSince1970: doubleValue)
                }
                if let intValue = try? container.decode(Int64.self) {
                    return Date(timeIntervalSince1970: TimeInterval(intValue))
                }

                // 2) Otherwise decode as string and try formats
                let dateString = try container.decode(String.self)

                // Try ISO8601 with fractional seconds first
                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let d = isoFormatter.date(from: dateString) { return d }

                // Try ISO8601 without fractional seconds
                isoFormatter.formatOptions = [.withInternetDateTime]
                if let d = isoFormatter.date(from: dateString) { return d }

                // Try a few common date formats (include microseconds)
                let df = DateFormatter()
                df.locale = Locale(identifier: "en_US_POSIX")
                let formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss.SSSZ", "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss"]
                for fmt in formats {
                    df.dateFormat = fmt
                    if let d = df.date(from: dateString) { return d }
                }

                // Try extracting numbers from /Date(1234567890)/ or similar
                if let regex = try? NSRegularExpression(pattern: "\\d+", options: []) {
                    let range = NSRange(location: 0, length: dateString.utf16.count)
                    if let match = regex.firstMatch(in: dateString, options: [], range: range) {
                        if let matchRange = Range(match.range, in: dateString) {
                            let numberString = String(dateString[matchRange])
                            if let ms = Double(numberString) {
                                // Only treat large numbers as epoch timestamps. Years like 2025 should not be
                                // interpreted as seconds since 1970. Use thresholds: >1e9 (seconds) or >1e12 (ms).
                                if ms > 1_000_000_000_000 { // milliseconds
                                    return Date(timeIntervalSince1970: ms/1000.0)
                                } else if ms > 1_000_000_000 { // seconds
                                    return Date(timeIntervalSince1970: ms)
                                }
                                // otherwise ignore small numeric matches (likely parts of the date string)
                            }
                        }
                    }
                }

                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode date string: \(dateString)"))
            }
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            print("[LoginViewViewModel] authResponse: \(authResponse)")

            if authResponse.isSuccess {
                self.token = authResponse.token
                self.loggedInUser = authResponse.user
                print("[LoginViewViewModel] login success, token set?: \(self.token != nil), user set?: \(self.loggedInUser != nil)")

                // Save token for future API calls
                UserDefaults.standard.set(authResponse.token, forKey: "jwtToken")
            } else {
                errorMessage = authResponse.message
                print("[LoginViewViewModel] login returned success=false message: \(authResponse.message)")
            }

        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
            print("[LoginViewViewModel] login network error: \(error)")
        }
        
        isLoading = false
    }
}



