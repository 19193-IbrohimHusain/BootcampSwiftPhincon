//
//  CategoryModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation

struct CategoryResponse: Codable {
    let meta: Meta
    let data: CategoryData
    
    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}

// MARK: - DataClass
struct CategoryData: Codable {
    let data: [CategoryModel]
    
    enum CodingKeys: String, CodingKey {
        case data
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
