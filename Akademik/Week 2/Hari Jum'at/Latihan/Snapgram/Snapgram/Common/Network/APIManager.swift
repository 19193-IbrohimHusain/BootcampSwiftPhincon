import Foundation

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    enum APIError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func fetchRequest<T: Codable>(endpoint: Endpoint,
                                         expecting type: T.Type, completion: @escaping(Result<T, Error>)-> Void) {
        guard let urlRequest = self.request(endpoint: endpoint) else {
            completion(.failure(APIError.failedToCreateRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }
    
    public func request(endpoint: Endpoint) -> URLRequest? {
        var url: URL {
            return URL(string: endpoint.urlString()) ?? URL(string: "")!
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method()
    
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonData =  try? JSONSerialization.data(withJSONObject: endpoint.parameters) {
            request.httpBody = jsonData
        }
        return request
    }
}
