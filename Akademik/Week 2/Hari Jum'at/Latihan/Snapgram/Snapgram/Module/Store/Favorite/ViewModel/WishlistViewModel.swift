//
//  WishlistViewModel.swift
//  Snapgram
//
//  Created by Phincon on 29/12/23.
//

import Foundation
import RxRelay

class WishlistViewModel: BaseViewModel {
    var favProduct = BehaviorRelay<[FavoriteProducts]?>(value: nil)
    
    func fetchFavProduct() {
        let items = CoreDataHelper.shared.fetchFavProducts()
        favProduct.accept(items)
    }
}
