import Foundation

enum Endpoint {
    case login(param: LoginParam)
    case register(param: RegisterParam)
    case fetchStory(param: StoryTableParam)
    case getDetailStory(String)
    case addNewStory(param: AddStoryParam)
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .register: return "/register"
        case .fetchStory: return "/stories"
        case .getDetailStory(let id): return "/stories/\(id)"
        case .addNewStory: return "/stories"
        }
    }
    
    var method: String {
        switch self {
        case .login, .register, .addNewStory: return "POST"
        case .fetchStory, .getDetailStory: return "GET"
        }
    }
    
    var bodyParam: [String: Any]? {
        switch self {
        case .fetchStory, .getDetailStory, .register, .login: return nil
        case .addNewStory(let param):
            return [
                "description": param.description,
                "photo": param.photo,
                "lat": param.lat,
                "long": param.long
            ]
        }
    }
    
    var queryParam: [String: Any]? {
        switch self {
        case .addNewStory, .getDetailStory, .register, .login: return nil
        case .fetchStory(let param):
            return [
                "page": param.page,
                "size": param.size,
                "location": param.location
            ]
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .login, .register: return nil
        case .addNewStory:
            return ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(retrieveToken())"]
        case .fetchStory, .getDetailStory: return ["Authorization": "Bearer \(retrieveToken())"]
        }
    }
    
    private func retrieveToken() -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecReturnData: kCFBooleanTrue!,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            print("Token not found in Keychain")
            return ""
        }
    }
    
    var urlString: String {
        return BaseConstant.baseUrl + path
    }
}
