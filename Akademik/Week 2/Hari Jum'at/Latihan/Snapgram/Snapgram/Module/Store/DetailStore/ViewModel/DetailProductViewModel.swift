//
//  DetailProductViewModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation
import RxSwift
import RxCocoa

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
