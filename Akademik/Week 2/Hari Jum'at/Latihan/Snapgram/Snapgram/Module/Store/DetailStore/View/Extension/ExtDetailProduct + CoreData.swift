//
//  ExtDetailStore + CoreData.swift
//  Snapgram
//
//  Created by Phincon on 02/01/24.
//

import Foundation
import UIKit

extension DetailProductViewController {
    internal func addItemToCoreData(for action: ProductCoreData) -> CoreDataResult {
        guard let user = try? BaseConstant.getUserFromUserDefaults(), let product = self.product, let image = self.image?.first else { return .failed }
        switch action {
        case .cart(let id):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(product.id),
                "name": product.name,
                "image": image.url,
                "price": product.price,
                "quantity": 1,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(Cart.self, for: .cart(id: id), productId: product.id, properties: properties)
        case .favorite(let id):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(product.id),
                "name": product.name,
                "imageLink": image.url,
                "price": product.price,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(FavoriteProducts.self, for: .favorite(id: id), productId: product.id, properties: properties)
        }
    }
    
    internal func resultHandler(for state: CoreDataResult, destination: String) {
        switch state {
        case .added:
            self.displayAlert(title: "Success", message: "Item Added To \(destination)", action: self.addAlertAction)
        case .failed:
            self.displayAlert(title: "Failed", message: "Failed To Add Item")
        case .deleted:
            self.displayAlert(title: "Success", message: "Item Deleted From \(destination)", action: self.addAlertAction)
        case .updated:
            self.displayAlert(title: "Success", message: "Item Added To \(destination)", action: self.addAlertAction)
        }
    }
    
    private func addAlertAction() -> UIAlertAction {
        guard let isCart = isCart else { return UIAlertAction() }
        let navigateToCartAction = UIAlertAction(title: isCart ? "See Cart" : "See Wishlist", style: .default) { _ in
            let vc = isCart ? CartViewController() : WishlistViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return navigateToCartAction
    }
}
