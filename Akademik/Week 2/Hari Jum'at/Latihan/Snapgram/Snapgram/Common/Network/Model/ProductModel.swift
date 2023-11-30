import Foundation

struct ProductResponse: Codable {
    let meta: Meta
    let data: ProductModel
    
    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}

struct Meta: Codable {
    let code: Int
    let status, message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case status, message
    }
}

// MARK: - DataClass
struct ProductData: Codable {
    let data: [ProductModel]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct ProductModel: Codable {
    let id: Int
    let name: String
    let price: Double
    let description: String
    let tags: String?
    let categoriesId: Int
    let category: CategoryModel
    let galleries: [GalleryModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, description, tags, category, galleries
        case categoriesId = "categories_id"
    }
}

struct CategoryModel: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct GalleryModel: Codable {
    let id: Int
    let productsId: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case productsId = "products_id"
    }
}
