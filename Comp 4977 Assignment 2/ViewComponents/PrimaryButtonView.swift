//
//  PrimaryButtonView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import SwiftUI

import SwiftUI

struct PrimaryButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
                .frame(height: 55)
                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                .overlay(
                    Text(title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                )
        }
    }
}


#Preview {
    PrimaryButtonView(title: "Preview Button") {
        print("Button pressed in preview")
    }
    .padding()
//    .background(Color.black)
}

