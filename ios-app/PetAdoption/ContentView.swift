import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            if authViewModel.currentUser?.role == "shelter" {
                // Shelter view - single dashboard
                ShelterDashboardView()
                    .environmentObject(authViewModel)
            } else {
                // User view - tabs with all features
                TabView {
                    HomeView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Label("Browse", systemImage: "pawprint.fill")
                        }
                    
                    RecommendationsView()
                        .tabItem {
                            Label("For You", systemImage: "heart.fill")
                        }
                    
                    AdoptionRequestsView()
                        .tabItem {
                            Label("Requests", systemImage: "doc.text.fill")
                        }
                    
                    ProfileView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
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
