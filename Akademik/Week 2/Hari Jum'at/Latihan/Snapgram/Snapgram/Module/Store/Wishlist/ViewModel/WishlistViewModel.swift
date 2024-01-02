//
//  WishlistViewModel.swift
//  Snapgram
//
//  Created by Phincon on 29/12/23.
//

import Foundation
import RxRelay

class WishlistViewModel: BaseViewModel {
    var favProduct = BehaviorRelay<[FavoriteProducts]>(value: [])
    
    func fetchFavProduct() {
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        if let items = try? CoreDataHelper.shared.fetchItems(FavoriteProducts.self, userId: user.userid) {
            favProduct.accept(items)
        }
    }
}
