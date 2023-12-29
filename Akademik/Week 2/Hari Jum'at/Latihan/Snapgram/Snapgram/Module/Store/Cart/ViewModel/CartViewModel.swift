//
//  CartViewModel.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation
import RxRelay
enum SectionCartTable {
    case main
}

class CartViewModel: BaseViewModel {
    var cartItems = BehaviorRelay<[Cart]?>(value: nil)
    
    func fetchCartItems() {
        let items = CoreDataHelper.shared.fetchCartItems()
        cartItems.accept(items)
    }
}
