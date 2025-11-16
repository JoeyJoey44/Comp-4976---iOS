//
//  AIViewViewModel.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-15.
//

import Foundation
import Combine

@MainActor
class AIViewViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    /// history: tuples of (role, text) where role is "user" or "assistant"
    @Published var history: [(role: String, text: String)] = []

    func sendQuestion() async {
        errorMessage = ""
        let question = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else {
            errorMessage = "Please enter a question."
            return
        }
        // Optimistically add user's message
        print("AIViewViewModel: sending question -> \(question)")
        history.append((role: "user", text: question))
        print("AIViewViewModel: history count after user append = \(history.count)")
        inputText = ""

        isLoading = true
        print("AIViewViewModel: isLoading = true")
        defer {
            isLoading = false
            print("AIViewViewModel: isLoading = false")
        }

        do {
            // POST the plain string (will be json-encoded as a JSON string) to /Chat
            print("AIViewViewModel: POST /Chat starting")
            let response: String = try await NetworkManager.shared.request(
                String.self,
                endpoint: "/Chat",
                method: .post,
                body: question,
                headers: nil
            )
            print("AIViewViewModel: POST /Chat completed; response length = \(response.count)")
            // Print the full response but truncate for safety
            let maxPreview = 4000
            let previewResponse: String
            if response.count > maxPreview {
                previewResponse = String(response.prefix(maxPreview)) + "... (truncated)"
            } else {
                previewResponse = response
            }
            print("AIViewViewModel: server response -> \(previewResponse)")
            history.append((role: "assistant", text: response))
            print("AIViewViewModel: history count after assistant append = \(history.count)")
        } catch NetworkError.httpError(let status, let data) {
            errorMessage = "Server error (\(status)): \(Utils.prettyJSON(data))"
            print("AIViewViewModel: HTTP error \(status) - \(Utils.prettyJSON(data))")
        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
            print("AIViewViewModel: Network error - \(error.localizedDescription)")
        }
    }

    func clearHistory() {
        history.removeAll()
        errorMessage = ""
        print("AIViewViewModel: history cleared")
    }
}
