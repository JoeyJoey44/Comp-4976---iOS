//
//  AIView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-15.
//

import SwiftUI

struct AIView: View {
    @StateObject private var vm = AIViewViewModel()

    // Convert raw assistant text into an AttributedString with links enabled and
    // remove markdown bold markers (`**`). Returns a Text view that preserves
    // wrapping and makes links tappable.
    private func attributedTextView(from raw: String) -> Text {
        let cleaned = raw.replacingOccurrences(of: "**", with: "")
        // Build an NSMutableAttributedString so we can apply Foundation attributes
        // (like .link) using the NSDataDetector ranges, then convert to AttributedString
        // for SwiftUI's Text view.
        let ns = cleaned as NSString
        let mutable = NSMutableAttributedString(string: cleaned)
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            detector.enumerateMatches(in: cleaned, options: [], range: NSRange(location: 0, length: ns.length)) { match, _, _ in
                guard let m = match, let url = m.url else { return }
                mutable.addAttribute(.link, value: url, range: m.range)
            }
        }

        if let attributed = try? AttributedString(mutable) {
            return Text(attributed)
        }

        return Text(cleaned)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [.backGround1, .backGround2],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    Text("AI Chat")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 12)

                    // Chat history
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(vm.history.enumerated()), id: \.offset) { idx, entry in
                                HStack {
                                    if entry.role == "user" {
                                        Spacer()
                                        Text(entry.text)
                                            .padding(10)
                                            .background(Color.blue.opacity(0.9))
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                            .frame(maxWidth: geometry.size.width * 0.75, alignment: .trailing)
                                    } else {
                                            attributedTextView(from: entry.text)
                                                .padding(10)
                                                .background(Color(.systemGray6).opacity(0.95))
                                                .foregroundColor(.primary)
                                                .cornerRadius(12)
                                                .frame(maxWidth: geometry.size.width * 0.75, alignment: .leading)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }

                    if !vm.errorMessage.isEmpty {
                        Text(vm.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Input area
                    VStack(spacing: 8) {
                        TextEditor(text: $vm.inputText)
                            .frame(height: 100)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground).opacity(0.12)))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)

                        HStack(spacing: 12) {
                            Button(action: {
                                Task { await vm.sendQuestion() }
                            }) {
                                HStack {
                                    if vm.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .padding(.trailing, 6)
                                    }
                                    Text("Send")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(LinearGradient(colors: [.backGround2, .backGround1], startPoint: .topLeading, endPoint: .bottomTrailing)))
                                .foregroundColor(.white)
                            }
                            .disabled(vm.isLoading)

                            Button(action: vm.clearHistory) {
                                Text("Clear")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.6)))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 12)
                }
            }
        }
    }
}

#Preview {
    AIView()
}
