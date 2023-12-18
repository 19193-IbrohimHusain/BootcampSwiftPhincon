//
//  DetailProductViewModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation
import RxSwift
import RxCocoa

enum SectionDetailProduct: Int, CaseIterable {
    case image, name, desc, recommendation
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .image:
            return ImageCell.self
        case .name:
            return NameCell.self
        case .desc:
            return DescriptionCell.self
        case .recommendation:
            return FYPCollectionCell.self
        }
    }
    
    static var sectionIdentifiers: [SectionDetailProduct: String] {
        return [
            .image: String(describing: ImageCell.self),
            .name: String(describing: NameCell.self),
            .desc: String(describing: DescriptionCell.self),
            .recommendation: String(describing: FYPCollectionCell.self),
        ]
    }
}

class DetailProductViewModel: BaseViewModel {
    var dataProduct = BehaviorRelay<ProductModel?>(value: nil)
    var recommendation = BehaviorRelay<[ProductModel]?>(value: nil)
    var imagePaging = BehaviorSubject<PagingInfo?>(value: nil)
    
    func fetchDetailProduct(param: ProductParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: DetailProductResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.dataProduct.accept(data.data)
                self.loadingState.accept(.finished)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(error)
            }
        }
    }
    
    func fetchProduct(param: ProductParam = ProductParam()) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.recommendation.accept(data.data.data)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
