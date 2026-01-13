import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var animals: [Animal] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading pets...")
                } else if animals.isEmpty {
                    VStack(spacing: 16) {
                        Text("🐾")
                            .font(.system(size: 60))
                        Text("Pet List Coming Soon")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Connect to backend to load animals")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(animals) { animal in
                        NavigationLink(destination: AnimalDetailView(animal: animal)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(animal.name)
                                    .font(.headline)
                                Text("\(animal.species.capitalized) - \(animal.breed)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text("\(animal.age) years")
                                    Text("•")
                                    Text(animal.size.capitalized)
                                    Text("•")
                                    Text(animal.gender.capitalized)
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Available Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                }
            }
            .refreshable {
                await refreshAnimals()
            }
            .onAppear {
                loadAnimals()
            }
        }
    }
    
    func loadAnimals() {
        isLoading = true
        Task {
            do {
                animals = try await APIService.shared.getAnimals()
                isLoading = false
            } catch {
                print("Error loading animals: \(error)")
                isLoading = false
            }
        }
    }
    
    func refreshAnimals() async {
        do {
            animals = try await APIService.shared.getAnimals()
        } catch {
            print("Error refreshing animals: \(error)")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
