//
//  DetailProductViewModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation
import RxSwift
import RxCocoa

enum SectionDetailProductTable: Int, CaseIterable {
    case image, name, desc, store, recommendation
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .image:
            return DetailImageTableCell.self
        case .name:
            return DetailNameTableCell.self
        case .desc:
            return DetailDescriptionTableCell.self
        default: return UITableViewCell.self
        }
    }
    
    static var sectionIdentifiers: [SectionDetailProductTable: String] {
        return [
            .image: String(describing: DetailImageTableCell.self),
            .name: String(describing: DetailNameTableCell.self),
            .desc: String(describing: DetailDescriptionTableCell.self),
        ]
    }
}

class DetailProductViewModel: BaseViewModel {
    var dataProduct = BehaviorRelay<ProductResponse?>(value: nil)
    
    func fetchDetailProduct(param: ProductParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.dataProduct.accept(data)
                self.loadingState.accept(.finished)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(error)
            }
        }
    }
}
