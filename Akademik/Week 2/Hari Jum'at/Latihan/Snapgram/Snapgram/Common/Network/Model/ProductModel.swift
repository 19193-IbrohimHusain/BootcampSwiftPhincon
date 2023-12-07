import Foundation

struct ProductResponse: Codable {
    let meta: Meta
    let data: ProductData
    
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
    let currentPage: Int
    let data: [ProductModel]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
    }
}

struct ProductModel: Codable, Hashable {
    let id: Int
    let name: String
    let price: Double
    let description: String
    let tags: String?
    let categoriesId: Int
    let category: CategoryModel
    let galleries: [GalleryModel]?
    
    // Custom implementation of the equality operator
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.price == rhs.price &&
        lhs.description == rhs.description &&
        lhs.tags == rhs.tags &&
        lhs.categoriesId == rhs.categoriesId &&
        lhs.category == rhs.category &&
        lhs.galleries == rhs.galleries
    }
    
    // Implementation of the hash(into:) method
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(price)
        hasher.combine(description)
        hasher.combine(tags)
        hasher.combine(categoriesId)
        hasher.combine(category)
        hasher.combine(galleries)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, description, tags, category, galleries
        case categoriesId = "categories_id"
    }
}

struct GalleryModel: Codable, Hashable {
    let id: Int
    let productsId: Int
    let url: String
    
    // Custom implementation of the equality operator
    static func == (lhs: GalleryModel, rhs: GalleryModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.productsId == rhs.productsId &&
        lhs.url == rhs.url
    }
    
    // Implementation of the hash(into:) method
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(productsId)
        hasher.combine(url)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case productsId = "products_id"
    }
}
