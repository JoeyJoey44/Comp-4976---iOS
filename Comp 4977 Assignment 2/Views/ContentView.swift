import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        Group{
            if viewModel.isSignedIn {
                TabBarView()
            } else {
                LoginView()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
