import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewViewModel()
    @EnvironmentObject var session: ContentViewViewModel
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(colors: [.backGround1, .backGround2],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Register")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                    
                    VStack(spacing: 20) {
                        // MARK: First name field
                        TextInputFieldView(
                            title: "First Name",
                            placeholder: "Enter your first name",
                            text: $viewModel.firstName
                        )
                        .frame(width: geometry.size.width * 0.85)

                        // MARK: Last name field
                        TextInputFieldView(
                            title: "Last Name",
                            placeholder: "Enter your last name",
                            text: $viewModel.lastName
                        )
                        .frame(width: geometry.size.width * 0.85)

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
                        
                        // MARK: Confirm Password field
                        TextInputFieldView(
                            title: "Confirm Password",
                            placeholder: "Re-enter your password",
                            text: $viewModel.confirmPassword,
                            isSecure: true
                        )
                        .frame(width: geometry.size.width * 0.85)
                    }
                    
                    // Show validation / server errors
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    // MARK: Register button
                    PrimaryButtonView(title: "Register"){
                        Task {
                            // Use view model validation
                            guard viewModel.validateInputs() else { return }

                            await viewModel.register()
                            if let user = viewModel.registeredUser {
                                // Update shared session and trigger profile validation
                                await MainActor.run {
                                    session.currentUser = user
                                    session.isSignedIn = true
                                }

                                // Validate session/profile via ContentViewViewModel
                                await session.validateSession()
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.55)
                    .padding(.top, 10)
                    .disabled(!viewModel.canRegister || viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.6 : 1.0)
                    
                    // Anchor to login page
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 16, weight: .medium))
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Log in")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                                .underline()
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

#Preview {
    NavigationView {
        RegisterView()
            .environmentObject(ContentViewViewModel())
    }
}
