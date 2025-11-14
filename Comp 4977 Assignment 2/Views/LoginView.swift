import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewViewModel()
    @State private var showRegister = false
    @State private var navigateHome = false
    @EnvironmentObject var session: ContentViewViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(colors: [.backGround1, .backGround2],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                // Centered VStack
                VStack(spacing: 30) {
                    Text("Login")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                    
                    VStack(spacing: 20) {
                        // MARK: Email field
                        TextInputFieldView(
                            title: "Email",
                            placeholder: "Enter your email",
                            text: $viewModel.email
                        )
                        .frame(width: geometry.size.width * 0.85)
                        
                        // MARK: Password field
                        TextInputFieldView(
                            title: "Password",
                            placeholder: "Enter your password",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        .frame(width: geometry.size.width * 0.85)
                    }
                    
                    // MARK: Login Button
                    PrimaryButtonView(title: "Log In") {
                        Task {
                            await viewModel.login() // call login
                            // If login succeeded, optimistically mark session as signed in
                            if let user = viewModel.loggedInUser {
                                // Update session on main actor so the UI can switch immediately
                                await MainActor.run {
                                    session.currentUser = user
                                    session.isSignedIn = true
                                }

                                // Also validate session/profile in background to ensure token is valid
                                Task {
                                    await session.validateSession()
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.55)
                    .padding(.top, 10)

                    // MARK: Navigation link to RegisterPage
                    HStack {
                        Text("Don’t have an account?")
                            .foregroundColor(.white.opacity(0.9))
                        Button(action: {
                            showRegister.toggle()
                        }) {
                            Text("Create one")
                                .underline()
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.top, 10)
                }
                // 👇 Center the whole form vertically & horizontally
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            // MARK: Present RegisterPage when tapped
            .fullScreenCover(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(session)
            }
        }
    }
}

#Preview {
    LoginView()
}
