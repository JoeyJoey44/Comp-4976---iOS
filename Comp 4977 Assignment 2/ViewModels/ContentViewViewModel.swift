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

    init() {
        print("[ContentViewViewModel] init")
        Task {
            await validateSession()
        }
    }

    func validateSession() async {
        let token = Utils.getToken()
        print("[ContentViewViewModel] validateSession - token present?: \(token != nil)")
        guard let token = token else {
            // MARK: No token = not signed in
            self.isSignedIn = false
            return
        }

        // Call backend to get profile using stored token via NetworkManager
        do {
            let userProfile: User = try await NetworkManager.shared.request(User.self,
                                                                            endpoint: "/api/Auth/profile",
                                                                            method: .get,
                                                                            body: nil,
                                                                            headers: nil)
            self.currentUser = userProfile
            self.isSignedIn = true
            print("[ContentViewViewModel] profile decoded: \(userProfile)")
        } catch NetworkError.httpError(let status, let data) {
            print("[ContentViewViewModel] validateSession - profile fetch status: \(status)")
            print("[ContentViewViewModel] profile body: \(Utils.prettyJSON(data))")
            logout()
        } catch {
            print("[ContentViewViewModel] Profile fetch failed:", error)
            logout()
        }
    }

    func logout() {
        Utils.removeToken()
        self.currentUser = nil
        self.isSignedIn = false
    }
}

