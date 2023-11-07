import Foundation

// MARK: - StoryResponse
struct StoryResponse: Codable {
    let error: Bool
    let message: String
    var listStory: [ListStory]?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case listStory
    }
}

// MARK: - ListStory
struct ListStory: Codable {
    let id, name, description: String
    let photoURL: String
    let createdAt: String
    let lat, lon: Double?
    var likesCount: Int = 45310
    var commentsCount: Int = 27280

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case photoURL = "photoUrl"
        case createdAt, lat, lon
    }
}
