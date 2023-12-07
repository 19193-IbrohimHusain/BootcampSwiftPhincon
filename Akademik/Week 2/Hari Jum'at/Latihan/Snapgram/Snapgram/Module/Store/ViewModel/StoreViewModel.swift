//
//  StoreViewModel.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation
import RxSwift
import RxRelay

enum SectionStoreTable: Int, CaseIterable {
    case search, carousel, popular, newArrival, forYouProduct
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .search:
            return SearchTableCell.self
        case .carousel:
            return CarouselTableCell.self
        case .popular:
            return PopularTableCell.self
        case .newArrival:
            return NATableCell.self
        case .forYouProduct:
            return FYPTableCell.self
        }
    }
    
    static var sectionIdentifiers: [SectionStoreTable: String] {
        return [
            .search: String(describing: SearchTableCell.self),
            .carousel: String(describing: CarouselTableCell.self),
            .popular: String(describing: PopularTableCell.self),
            .newArrival: String(describing: NATableCell.self),
            .forYouProduct: String(describing: FYPTableCell.self)
        ]
    }
}

enum SectionStoreCollection: Int, CaseIterable {
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
