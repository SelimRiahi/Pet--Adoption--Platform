import SwiftUI

struct AnimalDetailView: View {
    let animal: Animal
    @Environment(\.dismiss) var dismiss
    @State private var compatibility: CompatibilityResponse?
    @State private var isLoadingCompatibility = false
    @State private var isSubmitting = false
    @State private var adoptionSuccess = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with name and basic info
                VStack(alignment: .leading, spacing: 8) {
                    Text(animal.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(animal.breed) • \(animal.age) years old")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(animal.species.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Compatibility Score
                if let compatibility = compatibility {
                    HStack(spacing: 12) {
                        Text("❤️")
                            .font(.system(size: 40))
                        
                        VStack(alignment: .leading) {
                            Text("\(Int(compatibility.compatibility_score))% Match")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(getScoreColor(compatibility.compatibility_score))
                            
                            Text("AI Compatibility Score")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                } else if isLoadingCompatibility {
                    HStack {
                        ProgressView()
                        Text("Calculating compatibility...")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                
                // Details Card
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Age", value: "\(animal.age) years")
                    DetailRow(label: "Size", value: animal.size.capitalized)
                    DetailRow(label: "Gender", value: animal.gender.capitalized)
                    
                    if let energyLevel = animal.energyLevel {
                        DetailRow(label: "Energy Level", value: energyLevel.capitalized)
                    }
                    
                    if let goodWithKids = animal.goodWithKids {
                        DetailRow(label: "Good with Children", value: goodWithKids ? "Yes ✓" : "No")
                    }
                    
                    if let goodWithPets = animal.goodWithPets {
                        DetailRow(label: "Good with Pets", value: goodWithPets ? "Yes ✓" : "No")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // About Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("About")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(animal.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Success Message
                if adoptionSuccess {
                    Text("✓ Adoption request submitted successfully!")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Adopt Button
                if animal.status == "available" && !adoptionSuccess {
                    Button(action: submitAdoption) {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Adopt \(animal.name)")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSubmitting ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .disabled(isSubmitting)
                }
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .navigationTitle("Pet Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCompatibility()
        }
    }
    
    func loadCompatibility() {
        isLoadingCompatibility = true
        Task {
            do {
                compatibility = try await APIService.shared.getAnimalCompatibility(animalId: animal.id)
                isLoadingCompatibility = false
            } catch {
                print("Failed to load compatibility: \(error)")
                isLoadingCompatibility = false
            }
        }
    }
    
    func submitAdoption() {
        isSubmitting = true
        errorMessage = nil
        
        Task {
            do {
                let request = CreateAdoptionRequest(animalId: animal.id)
                _ = try await APIService.shared.createAdoptionRequest(request)
                isSubmitting = false
                adoptionSuccess = true
                
                // Auto-dismiss after 2 seconds
                try await Task.sleep(nanoseconds: 2_000_000_000)
                dismiss()
            } catch {
                isSubmitting = false
                errorMessage = error.localizedDescription
            }
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

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        AnimalDetailView(animal: Animal(
            id: "1",
            name: "Buddy",
            species: "dog",
            breed: "Golden Retriever",
            age: 3,
            gender: "male",
            size: "large",
            description: "Friendly and energetic dog",
            imageUrl: nil,
            shelterId: "1",
            status: "available",
            energyLevel: "high",
            goodWithKids: true,
            goodWithPets: true,
            specialNeeds: false,
            spaceRequirement: "large",
            compatibilityScore: nil
        ))
    }
}
