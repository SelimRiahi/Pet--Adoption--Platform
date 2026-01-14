import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let user: User
    let onSave: (User) -> Void
    
    @State private var housingType: String
    @State private var availableTime: Double
    @State private var experience: String
    @State private var hasChildren: Bool
    @State private var hasOtherPets: Bool
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self.user = user
        self.onSave = onSave
        _housingType = State(initialValue: user.housingType ?? "apartment")
        _availableTime = State(initialValue: user.availableTime ?? 5.0)
        _experience = State(initialValue: user.experience ?? "none")
        _hasChildren = State(initialValue: user.hasChildren)
        _hasOtherPets = State(initialValue: user.hasOtherPets)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Housing") {
                    Picker("Housing Type", selection: $housingType) {
                        Text("Apartment").tag("apartment")
                        Text("Small House").tag("house_small")
                        Text("Large House").tag("house_large")
                    }
                }
                
                Section("Experience") {
                    Picker("Experience Level", selection: $experience) {
                        Text("None").tag("none")
                        Text("Some").tag("some")
                        Text("Expert").tag("expert")
                    }
                }
                
                Section("Availability") {
                    Stepper("Available Time: \(Int(availableTime)) hours", value: $availableTime, in: 0...10, step: 1)
                }
                
                Section("Family") {
                    Toggle("Has Children", isOn: $hasChildren)
                    Toggle("Has Other Pets", isOn: $hasOtherPets)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(isSaving)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func saveProfile() {
        isSaving = true
        let updates = UpdateProfileRequest(
            housingType: housingType,
            availableTime: availableTime,
            experience: experience,
            hasChildren: hasChildren,
            hasOtherPets: hasOtherPets
        )
        
        Task {
            do {
                let updatedUser = try await APIService.shared.updateProfile(updates)
                isSaving = false
                onSave(updatedUser)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isSaving = false
            }
        }
    }
}

struct UpdateProfileRequest: Codable {
    let housingType: String?
    let availableTime: Double?
    let experience: String?
    let hasChildren: Bool?
    let hasOtherPets: Bool?
}
