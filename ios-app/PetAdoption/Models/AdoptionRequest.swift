import Foundation

struct AdoptionRequest: Codable, Identifiable {
    let id: String
    let animalId: String
    let userId: String
    let message: String?
    let shelterNotes: String?
    let status: String
    let compatibilityScore: Double?
    let createdAt: String
    let animal: Animal?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case animalId, userId, message, shelterNotes, status, compatibilityScore, createdAt, animal, user
    }
}

struct CreateAdoptionRequest: Codable {
    let animalId: String
    let message: String?
    
    init(animalId: String, message: String? = nil) {
        self.animalId = animalId
        self.message = message
    }
}

struct UpdateAdoptionStatusRequest: Codable {
    let status: String
    let shelterNotes: String?
    
    init(status: String, shelterNotes: String? = nil) {
        self.status = status
        self.shelterNotes = shelterNotes
    }
}
