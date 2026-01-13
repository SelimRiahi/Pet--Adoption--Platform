import Foundation

struct CompatibilityResponse: Codable {
    let compatibility_score: Double
    let recommendation: String?
}
