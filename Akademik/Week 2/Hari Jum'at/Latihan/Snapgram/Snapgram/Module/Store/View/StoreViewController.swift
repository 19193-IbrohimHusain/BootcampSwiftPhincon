//
//  FolderViewController.swift
//  Snapgram
//
//  Created by Phincon on 03/11/23.
//

import UIKit
import SkeletonView

class StoreViewController: BaseViewController {

    @IBOutlet weak var storeCollection: UICollectionView!
    
    
    internal let vc = DetailProductViewController()
    internal let collections = SectionStoreCollection.allCases
    internal let vm = StoreViewModel()
    internal var product: [ProductModel]?
    internal var section: [Section]?
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
//            guard let section = SectionStoreCollection(rawValue: indexPath.section) else { fatalError("Invalid section index") }
            
            switch product.cellTypes {
            case .search:
                let cell: SearchCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                return cell
            case .carousel:
                let cell1: CarouselCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let item = self.dataSource.itemIdentifier(for: indexPath) {
                    item.galleries?.forEach {
                        cell1.configure(with: $0)
                    }
                }
                return cell1
            case .popular:
                let cell2: PopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let item = self.dataSource.itemIdentifier(for: indexPath) {
                    cell2.configure(with: item)
                }
                return cell2
            case .forYouProduct:
                let cell3: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let item = self.dataSource.itemIdentifier(for: indexPath) {
                    cell3.configure(with: item)
                }
                return cell3
            default: return UICollectionViewCell()
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
                return NSCollectionLayoutSection.forYouPageSection()
            }
        })
        
        storeCollection.collectionViewLayout = layout
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionStoreCollection, ProductModel>()
        snapshot.appendSections(collections)
        if let product = product {
            if var section1 = product.first {
                section1.cellTypes = .search
                snapshot.appendItems([section1], toSection: .search)
            }
                        
            let section2 = product.prefix(5).map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .carousel
                return modifiedItem
            }
            let section3 = product.map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .popular
                return modifiedItem
            }
            let section4 = product.map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .forYouProduct
                return modifiedItem
            }
            snapshot.appendItems(section2, toSection: .carousel)
            snapshot.appendItems(section3, toSection: .popular)
            snapshot.appendItems(section4, toSection: .forYouProduct)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, var dataProduct = product?.data.data else {return}
            dataProduct.remove(at: 0)
            self.product = dataProduct
            self.reloadSnapshot()
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
            case .failed:
                DispatchQueue.main.async {
                    self.storeCollection.hideSkeleton()
                    self.storeCollection.addSubview(self.errorView)
                }
            }
        }).disposed(by: bag)
    }
}

extension StoreViewController: UICollectionViewDelegate {
    
}

extension StoreViewController: CarouselTableCellDelegate, PopularTableCellDelegate, NATableCellDelegate, FYPTableCellDelegate {
    func navigateToDetail(id: Int) {
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
