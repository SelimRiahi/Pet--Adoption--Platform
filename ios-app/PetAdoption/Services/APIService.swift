import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://localhost:3000"
    private var authToken: String?
    
    private init() {}
    
    func setAuthToken(_ token: String?) {
        self.authToken = token
        if let token = token {
            UserDefaults.standard.set(token, forKey: "authToken")
        } else {
            UserDefaults.standard.removeObject(forKey: "authToken")
        }
    }
    
    func getAuthToken() -> String? {
        return authToken ?? UserDefaults.standard.string(forKey: "authToken")
    }
    
    private func createRequest(endpoint: String, method: String, body: Data? = nil) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    // MARK: - Auth
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let loginRequest = LoginRequest(email: email, password: password)
        let body = try JSONEncoder().encode(loginRequest)
        
        guard let request = createRequest(endpoint: "/auth/login", method: "POST", body: body) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func register(email: String, password: String, name: String, role: String) async throws -> AuthResponse {
        let registerRequest = RegisterRequest(email: email, password: password, name: name, role: role)
        let body = try JSONEncoder().encode(registerRequest)
        
        guard let request = createRequest(endpoint: "/auth/register", method: "POST", body: body) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    // MARK: - Users
    
    func getProfile() async throws -> User {
        guard let request = createRequest(endpoint: "/users/profile", method: "GET") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func updateProfile(_ updateRequest: UpdateProfileRequest) async throws -> User {
        let body = try JSONEncoder().encode(updateRequest)
        
        guard let request = createRequest(endpoint: "/users/profile", method: "PATCH", body: body) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    // MARK: - Animals
    
    func getAnimals() async throws -> [Animal] {
        guard let request = createRequest(endpoint: "/animals", method: "GET") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Animal].self, from: data)
    }
    
    func getAnimal(id: String) async throws -> Animal {
        guard let request = createRequest(endpoint: "/animals/\(id)", method: "GET") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Animal.self, from: data)
    }
    
    func createAnimal(_ createRequest: CreateAnimalRequest) async throws -> Animal {
        let body = try JSONEncoder().encode(createRequest)
        
        guard let request = createRequest(endpoint: "/animals", method: "POST", body: body) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Animal.self, from: data)
    }
    
    func getRecommendations() async throws -> [Animal] {
        guard let request = createRequest(endpoint: "/animals/recommendations", method: "POST") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Animal].self, from: data)
    }
    
    func getAnimalCompatibility(animalId: String) async throws -> CompatibilityResponse {
        guard let request = createRequest(endpoint: "/animals/\(animalId)/compatibility", method: "GET") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CompatibilityResponse.self, from: data)
    }
    
    // MARK: - Adoption Requests
    
    func getAdoptionRequests() async throws -> [AdoptionRequest] {
        guard let request = createRequest(endpoint: "/adoption-requests", method: "GET") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([AdoptionRequest].self, from: data)
    }
    
    func createAdoptionRequest(_ createRequest: CreateAdoptionRequest) async throws -> AdoptionRequest {
        let body = try JSONEncoder().encode(createRequest)
        
        guard let request = createRequest(endpoint: "/adoption-requests", method: "POST", body: body) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(AdoptionRequest.self, from: data)
    }
    
    func updateAdoptionStatus(id: String, status: String) async throws -> AdoptionRequest {
        let updateRequest = UpdateAdoptionStatusRequest(status: status)
        let body = try JSONEncoder().encode(updateRequest)
        
        guard let request = createRequest(endpoint: "/adoption-requests/\(id)/status", method: "PATCH", body: body) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(AdoptionRequest.self, from: data)
    }
}
