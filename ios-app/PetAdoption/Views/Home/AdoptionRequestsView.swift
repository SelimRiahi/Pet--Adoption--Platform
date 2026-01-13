import SwiftUI

struct AdoptionRequestsView: View {
    @State private var requests: [AdoptionRequest] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading requests...")
                } else if requests.isEmpty {
                    VStack(spacing: 16) {
                        Text("📋")
                            .font(.system(size: 60))
                        Text("No Adoption Requests")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Your adoption requests will appear here")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(requests) { request in
                        VStack(alignment: .leading, spacing: 8) {
                            if let animal = request.animal {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(animal.name)
                                            .font(.headline)
                                        Text("\(animal.breed) • \(animal.age) years")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    StatusBadge(status: request.status)
                                }
                                
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
                                
                                if let notes = request.shelterNotes, !notes.isEmpty {
                                    Text("Notes: \(notes)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 4)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("My Adoption Requests")
            .refreshable {
                await refreshRequests()
            }
            .onAppear {
                loadRequests()
            }
        }
    }
    
    func loadRequests() {
        isLoading = true
        Task {
            do {
                requests = try await APIService.shared.getAdoptionRequests()
                isLoading = false
            } catch {
                print("Error loading requests: \(error)")
                isLoading = false
            }
        }
    }
    
    func refreshRequests() async {
        do {
            requests = try await APIService.shared.getAdoptionRequests()
        } catch {
            print("Error refreshing requests: \(error)")
        }
    }
}

struct StatusBadge: View {
    let status: String
    
    var body: some View {
        Text(status.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    var statusColor: Color {
        switch status.lowercased() {
        case "pending":
            return .orange
        case "approved":
            return .green
        case "rejected":
            return .red
        case "completed":
            return .blue
        default:
            return .gray
        }
    }
}

#Preview {
    AdoptionRequestsView()
}
