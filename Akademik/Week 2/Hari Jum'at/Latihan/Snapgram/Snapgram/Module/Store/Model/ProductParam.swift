//
//  ProductParam.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation

struct ProductParam {
    var id: Int
    var limit: Int
    var name: String
    var description: String
    var priceFrom: Int
    var priceTo: Int
    var tags: String
    var categories: Int
    
    init(id: Int = 1, limit: Int = 6, name: String = "Nike", description: String = "", priceFrom: Int = 1, priceTo: Int = 100000, tags: String = "popular", categories: Int = 1) {
        self.id = id
        self.limit = limit
        self.name = name
        self.description = description
        self.priceFrom = priceFrom
        self.priceTo = priceTo
        self.tags = tags
        self.categories = categories
    }
}
