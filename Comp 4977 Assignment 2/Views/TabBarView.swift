import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                        .foregroundStyle(.blue)
                    Text("Home")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.green)
                    Text("Settings")
                }
            
            AboutView()
                .tabItem {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.green)
                    Text("About")
                }

        }
        
    }
}

#Preview {
    TabBarView()
}
