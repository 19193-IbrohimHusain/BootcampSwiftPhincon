import Foundation
import Alamofire

enum EndpointProduct {
    case categories
    case products(param: ProductParam)
    
    var path: String {
        switch self {
        case .categories: return "/categories"
        case .products: return "/products"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories, .products: return .get
        }
    }
    
    var queryParams: [String: Any]? {
        switch self {
        case .products(let param):
            let params: [String: Any] = [
                "id" : param.id,
                "limit" : param.limit,
                "name" : param.name,
                "description" : param.description,
                "priceFrom" : param.priceFrom,
                "priceTo" : param.priceTo,
                "tags" : param.tags,
                "categories" : param.categories
            ]
            
            return params
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .categories, .products:
            return URLEncoding.queryString
        }
    }
    
    var urlString: String {
        return BaseConstant.urlProduct + path
    }
}
