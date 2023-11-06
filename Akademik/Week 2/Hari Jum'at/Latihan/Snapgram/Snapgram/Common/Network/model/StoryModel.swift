import Foundation

// MARK: - StoryResponse
struct StoryResponse: Codable {
    let error: Bool
    let message: String
    let listStory: [ListStory]?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case listStory = "list_story"
    }
}

// MARK: - ListStory
struct ListStory: Codable {
    let id, name, description: String
    let photoURL: String
    let createdAt: String
    let lat, lon: Double

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case photoURL = "photoUrl"
        case createdAt, lat, lon
    }
}
