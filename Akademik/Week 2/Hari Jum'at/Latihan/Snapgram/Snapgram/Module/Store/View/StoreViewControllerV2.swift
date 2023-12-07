//
//  StoreViewControllerV2.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit
import SkeletonView

class StoreViewControllerV2: BaseViewController {
    
    weak var storeCollection: UICollectionView!
    
    internal let vc = DetailProductViewController()
    internal let collections = SectionStoreCollection.allCases
    internal let vm = StoreViewModel()
    internal var product: [ProductModel]?
    private var dataSource: UICollectionViewDiffableDataSource<SectionStoreCollection, ProductModel>!
    private var layout: UICollectionViewCompositionalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchProduct(param: ProductParam())
    }
    
    private func setup() {
        setupNavigationBar(title: "SnapStore", image1: "line.horizontal.3", image2: "cart", action1: nil, action2: nil)
        storeCollection.delegate = self
        collections.forEach { storeCollection.registerCellWithNib($0.cellTypes) }
        setupDataSource()
        setupCompositionalLayout()
        bindData()
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: storeCollection) { collectionView, indexPath, product in
            guard let section = SectionStoreCollection(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .search:
                let cell: SearchCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                return cell
            case .carousel:
                let cell1: CarouselCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                product.galleries?.forEach { carousel in
                    cell1.configure(with: carousel)
                }
                return cell1
            case .popular:
                let cell2: PopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell2.configure(with: product)
                return cell2
            case .forYouProduct:
                let cell3: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell3.configure(with: product)
                return cell3
            }
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { sectionIndex, env in
            guard let section = SectionStoreCollection(rawValue: sectionIndex) else { fatalError("Invalid section index") }
            switch section {
            case .search:
                return NSCollectionLayoutSection.searchSection()
            case .carousel:
                return NSCollectionLayoutSection.carouselSection()
            case .popular:
                return NSCollectionLayoutSection.popularListSection()
            case .forYouProduct:
                return NSCollectionLayoutSection.forYouPageSection(env: env)
            }
        })
        
        storeCollection.collectionViewLayout = layout
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionStoreCollection, ProductModel>()
        snapshot.appendSections(collections)
        if let product = product {
            let data = Array(product.prefix(5))
            snapshot.appendItems(data, toSection: .carousel)
            snapshot.appendItems(product, toSection: .popular)
            snapshot.appendItems(product, toSection: .forYouProduct)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, var dataProduct = product?.data.data else {return}
            dataProduct.remove(at: 0)
            self.product = dataProduct
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.storeCollection.showAnimatedGradientSkeleton()
            case .finished:
                self.storeCollection.hideSkeleton()
                self.reloadSnapshot()
            case .failed:
                DispatchQueue.main.async {
                    self.storeCollection.hideSkeleton()
                    self.storeCollection.addSubview(self.errorView)
                }
            }
        }).disposed(by: bag)
    }
}

extension StoreViewControllerV2: UICollectionViewDelegate {
    
}

extension StoreViewControllerV2: CarouselTableCellDelegate, PopularTableCellDelegate, NATableCellDelegate, FYPTableCellDelegate {
    func navigateToDetail(id: Int) {
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
