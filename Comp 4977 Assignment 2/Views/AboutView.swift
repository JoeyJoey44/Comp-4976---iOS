//
//  About.swift
//  Comp 4977 Assignment 2
//
//  Created by Joseph Jahanshahi on 2025-11-06.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                RoundedRectangle(cornerRadius: 0.0, style: .continuous)
                    .ignoresSafeArea()
                    .foregroundStyle(LinearGradient(colors: [.backGround1, .backGround2], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: geometry.size.width * 1.0)
                    .frame(height: geometry.size.height * 1.0)
                    .zIndex(0.0)
                
                VStack{
                    Text("Andre, Joey, Yujin")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(.white))
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                }
                
                
}
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    AboutView()
}
