import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let user: User
    let onSave: (User) -> Void
    
    @State private var housingType: String
    @State private var hasYard: Bool
    @State private var experienceLevel: String
    @State private var timeAvailable: String
    @State private var hasChildren: Bool
    @State private var hasOtherPets: Bool
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self.user = user
        self.onSave = onSave
        _housingType = State(initialValue: user.housingType ?? "apartment")
        _hasYard = State(initialValue: user.hasYard ?? false)
        _experienceLevel = State(initialValue: user.experienceLevel ?? "beginner")
        _timeAvailable = State(initialValue: user.timeAvailable ?? "low")
        _hasChildren = State(initialValue: user.hasChildren ?? false)
        _hasOtherPets = State(initialValue: user.hasOtherPets ?? false)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Housing") {
                    Picker("Housing Type", selection: $housingType) {
                        Text("Apartment").tag("apartment")
                        Text("House").tag("house")
                    }
                    
                    Toggle("Has Yard", isOn: $hasYard)
                }
                
                Section("Experience") {
                    Picker("Experience Level", selection: $experienceLevel) {
                        Text("Beginner").tag("beginner")
                        Text("Intermediate").tag("intermediate")
                        Text("Advanced").tag("advanced")
                    }
                }
                
                Section("Availability") {
                    Picker("Time Available", selection: $timeAvailable) {
                        Text("Low").tag("low")
                        Text("Medium").tag("medium")
                        Text("High").tag("high")
                    }
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
            hasYard: hasYard,
            experienceLevel: experienceLevel,
            timeAvailable: timeAvailable,
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
    let housingType: String
    let hasYard: Bool
    let experienceLevel: String
    let timeAvailable: String
    let hasChildren: Bool
    let hasOtherPets: Bool
}
