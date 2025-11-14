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
}

#Preview {
    ContentView()
}
