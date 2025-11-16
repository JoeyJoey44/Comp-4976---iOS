//
//  SettingsPage.swift
//  Comp 4977 Assignment 2
//
//  Created by Joseph Jahanshahi on 2025-11-04.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var session: ContentViewViewModel
    @State private var showLogoutAlert = false
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                RoundedRectangle(cornerRadius: 0.0, style: .continuous)
                    .ignoresSafeArea()
                    .foregroundStyle(LinearGradient(colors: [.backGround1, .backGround2], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: geometry.size.width * 1.0)
                    .frame(height: geometry.size.height * 1.0)
                    .zIndex(0.0)
                
                
                VStack(spacing: 20){
                    Text("Settings")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(Color(.white))
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                    
                    // Dark Mode Toggle
                    HStack {
                        Text("Dark Mode")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color(.white))
                            .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                            .tint(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal, 30)

                    Spacer()
                }
                .padding(.top, 20)
                .zIndex(1.0)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    SettingsView()
}
