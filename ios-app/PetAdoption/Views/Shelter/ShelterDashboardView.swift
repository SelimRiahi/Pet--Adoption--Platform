import SwiftUI

struct ShelterDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @State private var animals: [Animal] = []
    @State private var requests: [AdoptionRequest] = []
    @State private var isLoadingAnimals = false
    @State private var isLoadingRequests = false
    @State private var showAddAnimal = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab Picker
                Picker("View", selection: $selectedTab) {
                    Text("My Animals (\(animals.count))").tag(0)
                    Text("Adoption Requests (\(requests.count))").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                if selectedTab == 0 {
                    animalsView
                } else {
                    requestsView
                }
            }
            .navigationTitle("Shelter Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab == 0 {
                        Button {
                            showAddAnimal = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                }
            }
            .sheet(isPresented: $showAddAnimal) {
                AddAnimalView(onSuccess: {
                    loadAnimals()
                })
            }
            .onAppear {
                loadAnimals()
                loadRequests()
            }
        }
    }
    
    var animalsView: some View {
        Group {
            if isLoadingAnimals {
                ProgressView("Loading animals...")
            } else if animals.isEmpty {
                VStack(spacing: 16) {
                    Text("🐾")
                        .font(.system(size: 60))
                    Text("No Animals Yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Add your first animal using the + button")
                        .foregroundColor(.secondary)
                }
            } else {
                List(animals) { animal in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(animal.name)
                                    .font(.headline)
                                Text("\(animal.breed) • \(animal.age) years")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            StatusBadge(status: animal.status)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .refreshable {
                    await refreshAnimals()
                }
            }
        }
    }
    
    var requestsView: some View {
        Group {
            if isLoadingRequests {
                ProgressView("Loading requests...")
            } else if requests.isEmpty {
                VStack(spacing: 16) {
                    Text("📋")
                        .font(.system(size: 60))
                    Text("No Requests Yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Adoption requests will appear here")
                        .foregroundColor(.secondary)
                }
            } else {
                List(requests) { request in
                    VStack(alignment: .leading, spacing: 12) {
                        // Request Header
                        HStack {
                            if let animal = request.animal {
                                VStack(alignment: .leading) {
                                    Text(animal.name)
                                        .font(.headline)
                                    Text(animal.breed)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            StatusBadge(status: request.status)
                        }
                        
                        // Requester Info
                        if let user = request.user {
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.secondary)
                                Text(user.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Compatibility Score
                        if let score = request.compatibilityScore {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text("Compatibility: \(Int(score))%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Action Buttons (only for pending requests)
                        if request.status == "pending" {
                            HStack(spacing: 12) {
                                Button {
                                    updateRequestStatus(requestId: request.id, status: "approved")
                                } label: {
                                    Text("✓ Approve")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(Color.green)
                                        .cornerRadius(8)
                                }
                                
                                Button {
                                    updateRequestStatus(requestId: request.id, status: "rejected")
                                } label: {
                                    Text("✕ Reject")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .refreshable {
                    await refreshRequests()
                }
            }
        }
    }
    
    func loadAnimals() {
        isLoadingAnimals = true
        Task {
            do {
                animals = try await APIService.shared.getAnimals()
                isLoadingAnimals = false
            } catch {
                print("Error loading animals: \(error)")
                isLoadingAnimals = false
            }
        }
    }
    
    func loadRequests() {
        isLoadingRequests = true
        Task {
            do {
                requests = try await APIService.shared.getAdoptionRequests()
                isLoadingRequests = false
            } catch {
                print("Error loading requests: \(error)")
                isLoadingRequests = false
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
    
    func refreshRequests() async {
        do {
            requests = try await APIService.shared.getAdoptionRequests()
        } catch {
            print("Error refreshing requests: \(error)")
        }
    }
    
    func updateRequestStatus(requestId: String, status: String) {
        Task {
            do {
                _ = try await APIService.shared.updateAdoptionStatus(id: requestId, status: status)
                loadRequests() // Reload to show updated status
            } catch {
                print("Error updating request: \(error)")
            }
        }
    }
}

#Preview {
    ShelterDashboardView()
        .environmentObject(AuthViewModel())
}
