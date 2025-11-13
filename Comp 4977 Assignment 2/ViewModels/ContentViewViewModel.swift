//
//  ContentViewViewModel.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation
import Combine

@MainActor
class ContentViewViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUser: User? = nil

    private let tokenKey = "jwtToken"

    init() {
        print("[ContentViewViewModel] init")
        Task {
            await validateSession()
        }
    }

    func validateSession() async {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        print("[ContentViewViewModel] validateSession - token present?: \(token != nil)")
        guard let token = token else {
            // MARK: No token = not signed in
            self.isSignedIn = false
            return
        }

        // Call backend to get profile using stored token
        guard let url = URL(string: "\(APIConfig.baseURL)/api/Auth/profile") else {
            self.isSignedIn = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Raw profile response for debugging
            if let raw = String(data: data, encoding: .utf8) {
                print("[ContentViewViewModel] raw profile JSON: \n\(raw)")
            } else {
                print("[ContentViewViewModel] raw profile: <non-utf8 data>")
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                self.isSignedIn = false
                return
            }

            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder -> Date in
                    let container = try decoder.singleValueContainer()

                    if let doubleValue = try? container.decode(Double.self) {
                        return Date(timeIntervalSince1970: doubleValue)
                    }
                    if let intValue = try? container.decode(Int64.self) {
                        return Date(timeIntervalSince1970: TimeInterval(intValue))
                    }

                    let dateString = try container.decode(String.self)

                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    if let d = isoFormatter.date(from: dateString) { return d }

                    isoFormatter.formatOptions = [.withInternetDateTime]
                    if let d = isoFormatter.date(from: dateString) { return d }

                    let df = DateFormatter()
                    df.locale = Locale(identifier: "en_US_POSIX")
                    let formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss.SSSZ", "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss"]
                    for fmt in formats {
                        df.dateFormat = fmt
                        if let d = df.date(from: dateString) { return d }
                    }

                    if let regex = try? NSRegularExpression(pattern: "\\d+", options: []) {
                        let range = NSRange(location: 0, length: dateString.utf16.count)
                        if let match = regex.firstMatch(in: dateString, options: [], range: range) {
                            if let matchRange = Range(match.range, in: dateString) {
                                let numberString = String(dateString[matchRange])
                                if let ms = Double(numberString) {
                                    // Only treat large numbers as epoch timestamps. Years like 2025 should not be
                                    // interpreted as seconds since 1970. Use thresholds: >1e9 (seconds) or >1e12 (ms).
                                    if ms > 1_000_000_000_000 {
                                        return Date(timeIntervalSince1970: ms/1000.0)
                                    } else if ms > 1_000_000_000 {
                                        return Date(timeIntervalSince1970: ms)
                                    }
                                    // otherwise ignore small numeric matches (likely parts of the date string)
                                }
                            }
                        }
                    }

                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode date string: \(dateString)"))
                }
                let userProfile = try decoder.decode(User.self, from: data)
                self.currentUser = userProfile
                self.isSignedIn = true
            } else {
                // Token invalid or expired
                print("[ContentViewViewModel] validateSession - profile fetch status: \(httpResponse.statusCode)")
                logout()
            }

        } catch {
            print("[ContentViewViewModel] Profile fetch failed:", error)
            logout()
        }
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        self.currentUser = nil
        self.isSignedIn = false
    }
}

