import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let role: String
    let housingType: String?
    let hasYard: Bool?
    let hasOtherPets: Bool?
    let experienceLevel: String?
    let activityLevel: String?
    let workSchedule: String?
    let hasFencedYard: Bool?
    let livingSituation: String?
    let householdSize: Int?
    let timeAvailable: String?
    let budgetLevel: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, name, role, housingType, hasYard, hasOtherPets
        case experienceLevel, activityLevel, workSchedule, hasFencedYard
        case livingSituation, householdSize, timeAvailable, budgetLevel
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
    let role: String
}

struct AuthResponse: Codable {
    let access_token: String
    let user: User
}

struct UpdateProfileRequest: Codable {
    let name: String?
    let housingType: String?
    let hasYard: Bool?
    let hasOtherPets: Bool?
    let experienceLevel: String?
    let activityLevel: String?
    let workSchedule: String?
    let hasFencedYard: Bool?
    let livingSituation: String?
    let householdSize: Int?
    let timeAvailable: String?
    let budgetLevel: String?
}
