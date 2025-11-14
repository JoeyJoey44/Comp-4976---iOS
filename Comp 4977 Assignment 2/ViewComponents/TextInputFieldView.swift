//
//  TextInputFieldView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import SwiftUI

struct TextInputFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var reveal: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
            
            HStack {
                if isSecure {
                    if reveal {
                        TextField(placeholder, text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        SecureField(placeholder, text: $text)
                    }

                    Button(action: { reveal.toggle() }) {
                        Image(systemName: reveal ? "eye" : "eye.slash")
                            .foregroundColor(.white.opacity(0.9))
                    }
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
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
        }
    }
}


#Preview {
    StatefulPreviewWrapper("") { binding in
        TextInputFieldView(
            title: "Email",
            placeholder: "Enter your email",
            text: binding
        )
        .padding()
    }
}

