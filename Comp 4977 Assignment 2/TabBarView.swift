import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Image(systemName: "house.fill")
                        .foregroundStyle(.blue)
                    Text("Home")
                }
            
            SettingsPage()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.green)
                    Text("Settings")
                }
            
            About()
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
