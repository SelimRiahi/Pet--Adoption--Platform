import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            if authViewModel.currentUser?.role == "shelter" {
                // Shelter view (simplified for now)
                HomeView()
                    .environmentObject(authViewModel)
            } else {
                // User view with tabs
                TabView {
                    HomeView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Label("Browse", systemImage: "pawprint.fill")
                        }
                    
                    AdoptionRequestsView()
                        .tabItem {
                            Label("My Requests", systemImage: "heart.fill")
                        }
                }
            }
        } else {
            NavigationStack {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
