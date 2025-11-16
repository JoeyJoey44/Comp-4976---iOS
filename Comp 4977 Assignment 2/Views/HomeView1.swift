import SwiftUI

struct HomeView1: View {
    @State private var messageText: String = ""
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                RoundedRectangle(cornerRadius: 0.0, style: .continuous)
                    .ignoresSafeArea()
                    .foregroundStyle(LinearGradient(colors: [.backGround1, .backGround2], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: geometry.size.width * 1.0)
                    .frame(height: geometry.size.height * 1.0)
                    .zIndex(0.0)
                
                
                VStack(spacing: 30){
                    Text("Assignment 2 App")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(Color(.white))
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                    
                    // Input Field Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Input Field")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                            .padding(.leading, geometry.size.width * 0.075)
                        
                        // Text Input Box
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                                .fill(Color.clear)
                                .frame(width: geometry.size.width * 0.85)
                                .frame(height: geometry.size.height * 0.15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.backGround2, .backGround1],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3.0
                                        )
                                )
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                            
                            // This message variable will be used for the payload of the API call..
                            TextEditor(text: $messageText)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .frame(width: geometry.size.width * 0.85)
                                .frame(height: geometry.size.height * 0.15)
                        }
                    }
                    
                    
                    Button(action: {
                        // Send action here
                        print("Send Button Pressed... We should add the API call here")
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                                .fill(LinearGradient(colors: [.backGround1, .backGround2], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: geometry.size.width * 0.5)
                                .frame(height: geometry.size.height * 0.08)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.backGround2, .backGround1],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 4)
                            
                            Text("Send")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(Color(.white))
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 4, y: 4)
                        }
                    }
                    .zIndex(1.0)
                    
                }
                .zIndex(1.0)
            }
        }
    }
}

#Preview {
    HomeView()
}
