import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
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
                        // Email
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
                        
                        // Password
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
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Confirm Password")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                            
                            SecureField("Re-enter your password", text: $confirmPassword)
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
                    
                    // Register button
                    Button(action: {
                        print("Register Button Pressed...")
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
                                Text("Register")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                            )
                    }
                    
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
    }
}
