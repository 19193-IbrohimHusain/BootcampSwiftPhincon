//
//  StoreViewModel.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation
import RxSwift
import RxRelay

enum SectionStoreCollection: Int, CaseIterable {
    case carousel, popular, forYouProduct
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .carousel:
            return CarouselCollectionCell.self
        case .popular:
            return PopularCollectionCell.self
        case .forYouProduct:
            return FYPCollectionViewCell.self
        }
    }
    
    enum HeaderFooterType {
        case popular(header: UICollectionReusableView.Type, footer: UICollectionReusableView.Type)
        case other(UICollectionReusableView.Type?)
    }
    
    // Use this property to get the header and footer types
    var headerFooterType: HeaderFooterType {
        switch self {
        case .carousel:
            return .other(CarouselFooter.self)
        case .popular:
            return .popular(header: PopularHeader.self, footer: PopularFooter.self)
        case .forYouProduct:
            return .other(FYPHeader.self)
        }
    }
    
    func registerHeaderFooterTypes(collectionView: UICollectionView) {
        switch headerFooterType {
        case .popular(let headerType, let footerType):
            register(headerType, kind: UICollectionView.elementKindSectionHeader, collectionView: collectionView)
            register(footerType, kind: UICollectionView.elementKindSectionFooter, collectionView: collectionView)
        case .other(let viewType):
            if let viewType = viewType, viewType == FYPHeader.self {
                register(viewType, kind: UICollectionView.elementKindSectionHeader, collectionView: collectionView)
            } else if let viewType = viewType, viewType == CarouselFooter.self {
                register(viewType, kind: UICollectionView.elementKindSectionFooter, collectionView: collectionView)
            }
        }
    }
    
    private func register(_ viewType: UICollectionReusableView.Type, kind: String, collectionView: UICollectionView) {
        collectionView.registerHeaderFooterNib(kind: kind, viewType)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
   
    
    static var sectionIdentifiers: [SectionStoreCollection: String] {
        return [
            .carousel: String(describing: CarouselCollectionCell.self),
            .popular: String(describing: PopularCollectionCell.self),
            .forYouProduct: String(describing: FYPCollectionViewCell.self)
        ]
    }
}

enum SectionFYPCollection: Int, CaseIterable {
    case allShoes, running, training, basketball, hiking, sport
}

struct PagingInfo: Equatable, Hashable {
    let sectionIndex: Int
    let currentPage: Int
}

class StoreViewModel: BaseViewModel {
    var productData = BehaviorRelay<[ProductModel]?>(value: nil)
    var sportShoes = BehaviorRelay<[ProductModel]?>(value: nil)
    var categoryData = BehaviorRelay<[CategoryModel]?>(value: nil)
    var pagingCarousel = BehaviorSubject<PagingInfo?>(value: nil)
    var pagingPopular = BehaviorSubject<PagingInfo?>(value: nil)
    
    func fetchProduct(param: ProductParam = ProductParam()) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.productData.accept(data.data.data)
                let sportShoes = data.data.data.filter {
                    $0.category.name == "Sport"
                }
                self.sportShoes.accept(sportShoes)
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
    
    func fetchCategories() {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .categories, expecting: CategoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.categoryData.accept(data.data.data)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
            
        }
    }
}
