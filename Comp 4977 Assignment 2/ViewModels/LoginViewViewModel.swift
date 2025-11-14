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
        defer { isLoading = false }
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            isLoading = false
            return
        }
        
        let loginPayload = [
            "email": email,
            "password": password
        ]
        
        do {
            // Use NetworkManager to perform request
            let authResponse: AuthResponse = try await NetworkManager.shared.request(
                AuthResponse.self,
                endpoint: Config.loginEndpoint,
                method: .post,
                body: loginPayload,
                headers: nil
            )
            print("[LoginViewViewModel] authResponse: \(authResponse)")
            
            if authResponse.isSuccess {
                self.token = authResponse.token
                self.loggedInUser = authResponse.user
                print("[LoginViewViewModel] login success, token set?: \(self.token != nil), user set?: \(self.loggedInUser != nil)")
                
                // Save token for future API calls
                Utils.saveToken(authResponse.token)
            } else {
                self.errorMessage = authResponse.message
                print("[LoginViewViewModel] login returned success=false message: \(authResponse.message)")
            }
            
        } catch NetworkError.httpError(let status, let data) {
            self.errorMessage = "Login failed (\(status)): \(Utils.prettyJSON(data))"
            print("[LoginViewViewModel] login http error: \(errorMessage)")
        } catch {
            self.errorMessage = "Network error: \(error.localizedDescription)"
            print("[LoginViewViewModel] login network error: \(error)")
        }
    }
}



