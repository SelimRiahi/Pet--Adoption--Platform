import SwiftUI

struct RecommendationsView: View {
    @State private var recommendations: [Animal] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Finding your perfect match...")
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Text("❌")
                            .font(.system(size: 60))
                        Text("Error Loading Recommendations")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            loadRecommendations()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if recommendations.isEmpty {
                    VStack(spacing: 16) {
                        Text("💝")
                            .font(.system(size: 60))
                        Text("No Recommendations Yet")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Update your profile to get personalized pet recommendations")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List(recommendations) { animal in
                        NavigationLink(destination: AnimalDetailView(animal: animal)) {
                            HStack(spacing: 16) {
                                // Compatibility Score Badge
                                if let score = animal.compatibilityScore {
                                    VStack {
                                        Text("\(Int(score))%")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(getScoreColor(score))
                                        Text("Match")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 60)
                                }
                                
                                // Animal Info
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
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("AI Recommendations")
            .refreshable {
                await refreshRecommendations()
            }
            .onAppear {
                loadRecommendations()
            }
        }
    }
    
    func loadRecommendations() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                recommendations = try await APIService.shared.getRecommendations()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func refreshRecommendations() async {
        do {
            recommendations = try await APIService.shared.getRecommendations()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getScoreColor(_ score: Double) -> Color {
        switch score {
        case 80...100:
            return .green
        case 65..<80:
            return .blue
        case 45..<65:
            return .orange
        default:
            return .red
        }
    }
}

#Preview {
    RecommendationsView()
}
