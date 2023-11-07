import Foundation

enum Endpoint {
    case login(param: LoginParam)
    case register(param: RegisterParam)
    case fetchStory
    case getDetailStory(Int)
    case addNewStory
    
    func path() -> String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        case .fetchStory:
            return "/stories"
        case .getDetailStory(let id):
            return "/stories/:\(id)"
        case .addNewStory:
            return "/stories"
        }
    }
    
    func method() -> String {
        switch self {
        case .login, .register, .addNewStory:
            return "POST"
        case .fetchStory, .getDetailStory(_):
            return "GET"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .addNewStory:
            return nil
        case .fetchStory, .getDetailStory(_):
            return nil
        case .register(let param):
            let params: [String: Any] = [
                "name" : param.name,
                "email" : param.email,
                "password" : param.password
            ]
            return params
        case .login(let param):
            let params: [String: Any] = [
                "email": param.email,
                "password": param.password
            ]
            return params
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .login, .register:
            return nil
        case .addNewStory:
            let params: [String: Any]? = ["Content-Type": "multipart/form-data", "Authorization": "Bearer <token>" ]
            return params
        case .fetchStory, .getDetailStory(_):
            let params: [String: Any]? = ["Authorization": "Bearer \(self.retrieveToken())"]
            return params
        }
    }
    
    func retrieveToken() -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecReturnData: kCFBooleanTrue!,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            print("Stored token: \(token)")
            return token
        } else {
            print("Token not found in Keychain")
            return ""
        }
    }
    
    func urlString() -> String {
        return BaseConstant.baseUrl + self.path()
    }
}
