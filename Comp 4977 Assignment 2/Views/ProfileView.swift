//
//  ProfileView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-15.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()
    @EnvironmentObject var session: ContentViewViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [.backGround1, .backGround2],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 16)

                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .foregroundColor(.white)
                    } else if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if let u = viewModel.user ?? session.currentUser {
                        Form {
                            Section {
                                LabeledContent("Name:", value: "\(u.firstName) \(u.lastName)")
                                LabeledContent("Email:", value: u.email)
                                LabeledContent("Created:", value: viewModel.formattedDate(u.createdAt))
                                LabeledContent("Last login:", value: viewModel.formattedDate(u.lastLoginDate))
                            }
                            .listRowBackground(Color.clear)
                        }
                        .scrollContentBackground(.hidden)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                        .padding(.horizontal, 20)
                    } else {
                        Text("No profile available")
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Text("Log Out")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .alert("Confirm Logout", isPresented: $showLogoutAlert) {
                        Button("Log Out", role: .destructive) {
                            session.logout()
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .onAppear {
            Task {
                // Prefer session's user if available to avoid redundant network call
                if let sessionUser = session.currentUser {
                    await MainActor.run { viewModel.user = sessionUser }
                } else {
                    await viewModel.fetchProfile()
                }
            }
        }
    }
}

#Preview {
    // Provide a fake session with a sample user so the preview renders without network calls.
    let vm = ContentViewViewModel()
    vm.currentUser = User(
        id: "32beaa19-b72d-4b11-8bce-6f16a5efbe0e",
        firstName: "Alice",
        lastName: "Anderson",
        email: "aa@aa.aa",
        createdAt: Date(timeIntervalSince1970: 1760000000), // sample date
        lastLoginDate: Date(timeIntervalSince1970: 1760000100)
    )
    return ProfileView()
        .environmentObject(vm)
}
