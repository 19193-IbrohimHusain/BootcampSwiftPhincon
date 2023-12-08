//
//  StoreViewModel.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation
import RxSwift
import RxRelay

enum SectionStoreCollection: Int, Hashable, CaseIterable {
    case search, carousel, popular, forYouProduct
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .search:
            return SearchCollectionCell.self
        case .carousel:
            return CarouselCollectionCell.self
        case .popular:
            return PopularCollectionCell.self
        case .forYouProduct:
            return FYPCollectionCell.self
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
   
    
    static var sectionIdentifiers: [SectionStoreCollection: String] {
        return [
            .search: String(describing: SearchCollectionCell.self),
            .carousel: String(describing: CarouselCollectionCell.self),
            .popular: String(describing: PopularCollectionCell.self),
            .forYouProduct: String(describing: FYPCollectionCell.self)
        ]
    }
}

class StoreViewModel: BaseViewModel {
    var productData = BehaviorRelay<ProductResponse?>(value: nil)
    
    func fetchProduct(param: ProductParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.productData.accept(data)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
