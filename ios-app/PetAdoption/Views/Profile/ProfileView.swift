import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var user: User?
    @State private var isLoading = false
    @State private var isEditing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView("Loading profile...")
                        .padding()
                } else if let user = user {
                    VStack(spacing: 20) {
                        // Profile Header
                        VStack(spacing: 8) {
                            Image(systemName: user.role == "shelter" ? "building.2.fill" : "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.blue)
                            
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(user.role.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .background(user.role == "shelter" ? Color.orange.opacity(0.2) : Color.blue.opacity(0.2))
                                .foregroundColor(user.role == "shelter" ? .orange : .blue)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                        
                        Divider()
                        
                        // Lifestyle Information (only for adopters)
                        if user.role == "user" {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Lifestyle Information")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                VStack(spacing: 12) {
                                    InfoRow(label: "Housing Type", value: user.housingType?.capitalized ?? "Not set")
                                    InfoRow(label: "Experience", value: user.experience?.capitalized ?? "None")
                                    InfoRow(label: "Available Time", value: "\(Int(user.availableTime ?? 5)) hours/day")
                                    InfoRow(label: "Has Children", value: user.hasChildren ? "Yes" : "No")
                                    InfoRow(label: "Has Other Pets", value: user.hasOtherPets ? "Yes" : "No")
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                
                                Button(action: { isEditing = true }) {
                                    Text("Edit Profile")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Logout Button
                        Button(action: { authViewModel.logout() }) {
                            Text("Logout")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Failed to load profile")
                            .font(.title3)
                        Button("Retry") {
                            loadProfile()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                loadProfile()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $isEditing) {
                if let user = user {
                    EditProfileView(user: user, onSave: { updatedUser in
                        self.user = updatedUser
                        loadProfile()
                    })
                }
            }
        }
    }
    
    func loadProfile() {
        isLoading = true
        Task {
            do {
                user = try await APIService.shared.getProfile()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
            }
        }
    }
}

struct InfoRow: View {
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
    ProfileView()
        .environmentObject(AuthViewModel())
}
