import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        Group{
            if viewModel.isSignedIn {
//                TabBarView()
                accountView
            } else {
                LoginView()
            }
        }
        .environmentObject(viewModel)
    }
    
    @ViewBuilder
    var accountView: some View {
        VStack {
            TabView {
                // MARK: Home
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.blue)
                        Text("Home")
                    }
                
                // MARK: AI
//                AIView()
                
                // MARK: Profile
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundStyle(.blue)
                        Text("Profile")
                    }
                
                // MARK: Settings
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.green)
                        Text("Settings")
                    }
                
                // MARK: About
                AboutView()
                    .tabItem {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.green)
                        Text("About")
                    }

            }
        }
    }
}

#Preview {
    ContentView()
}
