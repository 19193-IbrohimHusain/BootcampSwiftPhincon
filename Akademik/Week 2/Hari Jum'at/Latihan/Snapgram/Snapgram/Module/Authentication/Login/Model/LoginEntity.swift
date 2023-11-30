import Foundation

struct LoginParam {
    let email, password: String
}

struct User: Codable {
    let email: String
    let username: String
    let userid: String
}
