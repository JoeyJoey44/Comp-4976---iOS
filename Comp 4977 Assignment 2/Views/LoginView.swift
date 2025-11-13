import SwiftUI

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showRegister = false

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
                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                            
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(colors: [.backGround2, .backGround1],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing),
                                            lineWidth: 3
                                        )
                                        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                                )
                                .frame(width: geometry.size.width * 0.85)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                            
                            SecureField("Enter your password", text: $password)
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(colors: [.backGround2, .backGround1],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing),
                                            lineWidth: 3
                                        )
                                        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                                )
                                .frame(width: geometry.size.width * 0.85)
                        }
                    }
                    
                    // Login Button
                    Button(action: {
                        print("Log In Button Pressed...")
                    }) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(colors: [.backGround1, .backGround2],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(colors: [.backGround2, .backGround1],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing),
                                        lineWidth: 1.5
                                    )
                            )
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.08)
                            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                            .overlay(
                                Text("Log In")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                            )
                    }
                    .padding(.top, 10)

                    // Navigation link to RegisterPage
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
            // Present RegisterPage when tapped
            .fullScreenCover(isPresented: $showRegister) {
                RegisterPage()
            }
        }
    }
}

#Preview {
    LoginPage()
}
