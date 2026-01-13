import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let _ = apiService.getAuthToken() {
            isAuthenticated = true
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.login(email: email, password: password)
                apiService.setAuthToken(response.access_token)
                currentUser = response.user
                isAuthenticated = true
                isLoading = false
            } catch {
                errorMessage = "Login failed: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func register(email: String, password: String, name: String, role: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.register(email: email, password: password, name: name, role: role)
                apiService.setAuthToken(response.access_token)
                currentUser = response.user
                isAuthenticated = true
                isLoading = false
            } catch {
                errorMessage = "Registration failed: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func logout() {
        apiService.setAuthToken(nil)
        currentUser = nil
        isAuthenticated = false
    }
}
