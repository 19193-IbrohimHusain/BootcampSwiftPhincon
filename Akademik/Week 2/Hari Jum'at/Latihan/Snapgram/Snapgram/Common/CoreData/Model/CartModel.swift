//
//  CartModel.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation

struct CartModel: Hashable {
    let userID: String
    let productID: Int
    let name: String
    let price: Double
    let quantity: Int
    let image: String
    
    static func == (lhs: CartModel, rhs: CartModel) -> Bool {
        return lhs.productID == rhs.productID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(productID)
    }
}
