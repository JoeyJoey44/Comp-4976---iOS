//
//  ProfileViewViewModel.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-15.
//

import Foundation
import Combine

@MainActor
class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    init(user: User? = nil) {
        self.user = user
    }

    func fetchProfile() async {
        errorMessage = ""
        isLoading = true
        defer { isLoading = false }
        print("[ProvileViewViewModel] Fetching profile...]")
        
        do {
            let fetched: User = try await NetworkManager.shared.request(
                User.self,
                endpoint: Config.profileEndpoint,
                method: .get,
                body: nil,
                headers: nil
            )
            self.user = fetched
            print("[ProvileViewViewModel] Profile fetched: \(String(describing: self.user))")
        } catch NetworkError.httpError(let status, let data) {
            self.errorMessage = "Profile fetch failed (\(status)): \(Utils.prettyJSON(data))"
        } catch {
            self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
        }
    }

    func formattedDate(_ date: Date?) -> String {
        guard let d = date else { return "—" }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: d)
    }
}
