import Foundation

// MARK: - DetailStoryResponse
struct DetailStoryResponse: Codable {
    let error: Bool
    let message: String
    let story: Story?
    
    enum CodingKeys: String, CodingKey {
        case error, message
        case story
    }
}

// MARK: - Story
struct Story: Codable {
    let id, name, description: String
    let photoURL: String
    let createdAt: String
    let lat, lon: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case photoURL = "photoUrl"
        case createdAt, lat, lon
    }
}
