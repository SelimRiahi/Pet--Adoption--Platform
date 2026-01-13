import Foundation

struct Animal: Codable, Identifiable {
    let id: String
    let name: String
    let species: String
    let breed: String
    let age: Int
    let gender: String
    let size: String
    let description: String
    let imageUrl: String?
    let shelterId: String
    let status: String
    let energyLevel: String?
    let goodWithKids: Bool?
    let goodWithPets: Bool?
    let specialNeeds: Bool?
    let spaceRequirement: String?
    let compatibilityScore: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, species, breed, age, gender, size, description
        case imageUrl, shelterId, status, energyLevel, goodWithKids
        case goodWithPets, specialNeeds, spaceRequirement, compatibilityScore
    }
}

struct CreateAnimalRequest: Codable {
    let name: String
    let species: String
    let breed: String
    let age: Int
    let gender: String
    let size: String
    let description: String
    let imageUrl: String?
    let energyLevel: String?
    let goodWithKids: Bool?
    let goodWithPets: Bool?
    let specialNeeds: Bool?
    let spaceRequirement: String?
}
