import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let error: Bool
    let message: String?
    let loginResult: LoginResult?

}

// MARK: - LoginResult
struct LoginResult: Codable {
    let userID, name, token: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, token
    }
}
