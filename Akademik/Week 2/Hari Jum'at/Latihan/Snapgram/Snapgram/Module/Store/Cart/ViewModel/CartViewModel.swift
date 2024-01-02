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
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        let items = try? CoreDataHelper.shared.fetchItems(Cart.self, userId: user.userid)
        cartItems.accept(items)
    }
}
