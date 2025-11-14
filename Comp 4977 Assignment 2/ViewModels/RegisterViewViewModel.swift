//
//  RegisterViewViewModel.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-13.
//

import Foundation
import Combine

@MainActor
class RegisterViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var registeredUser: User? = nil
    @Published var token: String? = nil
    
    func register() async {
        errorMessage = ""
        isLoading = true
        print("[RegisterViewViewModel] Registering user...")
        defer { isLoading = false }
        // Validate inputs before attempting network call
        guard validateInputs() else { return }
        
        let registerPayload: [String: String] = [
            "email": email,
            "password": password,
            "firstName": firstName,
            "lastName": lastName
        ]
        
        do {
            let authResponse: AuthResponse = try await NetworkManager.shared.request(
                AuthResponse.self,
                endpoint: Config.registerEndpoint,
                method: .post,
                body: registerPayload,
                headers: nil
            )
            print("[RegisterViewViewModel] authResponse: \(authResponse)")
            
            if authResponse.isSuccess {
                self.token = authResponse.token
                self.registeredUser = authResponse.user
                print("[RegisterViewViewModel] Registered user: \(String(describing: self.registeredUser))")
                
                // Persist token for future API calls
                Utils.saveToken(authResponse.token)
            } else {
                self.errorMessage = authResponse.message
                print("[RegisterViewViewModel] Registration failed: \(authResponse.message)")
            }
        } catch NetworkError.httpError(let status, let data) {
            self.errorMessage = "Registration failed (\(status)): \(Utils.prettyJSON(data))"
            print("[RegisterViewViewModel] Registration failed: \(errorMessage)")
        } catch {
            self.errorMessage = "Network error: \(error.localizedDescription)"
            print("[RegisterViewViewModel] Network error: \(error)")
        }
    }

    // MARK: - Validation helpers
    /// Validate the input fields and set `errorMessage` when invalid.
    /// - Returns: true if inputs are valid, false otherwise.
    func validateInputs() -> Bool {
        // Trimmed checks
        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "First name is required."
            return false
        }
        if lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Last name is required."
            return false
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Email is required."
            return false
        }
        if password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Password and confirmation are required."
            return false
        }
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }

        // All good
        errorMessage = ""
        return true
    }

    /// Convenience computed property used by the view to enable/disable the register button.
    var canRegister: Bool {
        // Basic checks (do not change `errorMessage` here)
        let firstOk = !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let lastOk = !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let emailOk = !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let passwordsOk = !password.isEmpty && !confirmPassword.isEmpty && (password == confirmPassword)
        return firstOk && lastOk && emailOk && passwordsOk && !isLoading
    }
}
