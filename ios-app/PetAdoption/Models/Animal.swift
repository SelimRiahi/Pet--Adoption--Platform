import Foundation

struct Animal: Codable, Identifiable {
    let id: String
    let name: String
    let species: String
    let breed: String
    let age: Int
    let size: String
    let description: String
    let imageUrl: String?
    let shelterId: String
    let status: String
    let energyLevel: Int
    let goodWithChildren: Bool
    let goodWithPets: Bool
    let compatibilityScore: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, species, breed, age, size, description
        case imageUrl, shelterId, status, energyLevel
        case goodWithChildren, goodWithPets, compatibilityScore
    }
}

struct CreateAnimalRequest: Codable {
    let name: String
    let species: String
    let breed: String
    let age: Int
    let size: String
    let energyLevel: Int
    let goodWithChildren: Bool
    let goodWithPets: Bool
    let description: String
    let imageUrl: String?
}
