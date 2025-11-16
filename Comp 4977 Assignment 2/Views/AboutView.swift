//
//  About.swift
//  Comp 4977 Assignment 2
//
//  Created by Joseph Jahanshahi on 2025-11-06.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    let bubbleGumPink = Color(red: 9.9, green: 0.7, blue: 0.9)
    // Floating / animation state
    @State private var isVisible = false
    @State private var glow = false
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0

    var body: some View {
        ZStack {
            // Background Image (ensure `aboutBG` exists in Assets)
            Image("aboutBG")
                .resizable()
                .scaledToFill()
                // Zoom toward the top of the image
                .scaleEffect(1.25, anchor: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
                .ignoresSafeArea()
                .overlay(
                    LinearGradient(
                        colors: [.black.opacity(0.4), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )

            // Frosted Glass Card
            VStack(spacing: 20) {
                GlowingText(text: "Team Members", color: bubbleGumPink, glow: $glow)
                    .font(.title)
                    .fontWeight(.semibold)

                VStack(spacing: 10) {
                    GlowingText(text: "Yujin - A12345678", color: bubbleGumPink, glow: $glow)
                    GlowingText(text: "Joey - A12345679", color: bubbleGumPink, glow: $glow)
                    GlowingText(text: "Andre Hindarmara - A01075140", color: bubbleGumPink, glow: $glow)
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 30)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(radius: 15)
            .multilineTextAlignment(.center)
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.95)
            .offset(x: offsetX, y: offsetY)
            .animation(.easeOut(duration: 1), value: isVisible)
            .onAppear {
                isVisible = true
                glow = true
                startFloating()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // MARK: - Floating Animation
    func startFloating() {
        // Use an explicit repeating animation to change offset values periodically
        withAnimation(
            .easeInOut(duration: Double.random(in: 3...5))
            .repeatForever(autoreverses: true)
        ) {
            offsetX = CGFloat.random(in: -20...20)
            offsetY = CGFloat.random(in: -30...30)
        }
    }
}

// MARK: - Reusable Glowing Text Component
struct GlowingText: View {
    let text: String
    let color: Color
    @Binding var glow: Bool

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(color)
            .shadow(color: color.opacity(glow ? 1 : 0.3), radius: glow ? 15 : 4)
            .scaleEffect(glow ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                value: glow
            )
    }
}

#Preview {
    AboutView()
}
