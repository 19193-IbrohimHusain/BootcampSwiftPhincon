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
    
    internal let collections = SectionStoreCollection.allCases
    internal let vm = StoreViewModel()
    internal var product: [ProductModel]?
    internal var category: [CategoryModel]?
    internal var fyp: [ProductModel] = []
    internal var currentIndex = 0
    internal var timer: Timer?
    internal var isCarouselSectionVisible: Bool?
    internal var headerFYP: UICollectionView!
    internal var snapshot = NSDiffableDataSourceSnapshot<SectionStoreCollection, ProductModel>()
    private var layout: UICollectionViewCompositionalLayout!
    
    internal var dataSource: StoreViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func setup() {
        setupNavigationBar(title: "SnapStore", image1: "magnifyingglass", image2: "cart", action1: #selector(navigateToSearch), action2: #selector(navigateToCart))
        setupErrorView()
        setupCollectionView()
        setupDataSource()
        setupCompositionalLayout()
        bindData()
    }
    
    private func setupCollectionView() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storeCollection.refreshControl = refreshControl
        storeCollection.delegate = self
        collections.forEach {
            storeCollection.registerCellWithNib($0.cellTypes)
            $0.registerHeaderFooterTypes(collectionView: storeCollection)
        }
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: storeCollection) { [weak self] (collectionView, indexPath, product) in
            guard let self = self else { return UICollectionViewCell() }
            return self.dequeueCell(collectionView, cellForItemAt: indexPath, product: product)
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            return self.dequeueHeaderFooter(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
    
    internal func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self, let section = SectionStoreCollection(rawValue: sectionIndex) else { fatalError("Invalid section index") }
            switch section {
            case .carousel:
                return NSCollectionLayoutSection.carouselSection(pagingInfo: self.vm.pagingCarousel)
            case .popular:
                return NSCollectionLayoutSection.popularListSection(pagingInfo: self.vm.pagingPopular)
            case .forYouProduct:
                return NSCollectionLayoutSection.forYouPageSection(env: env)
            }
        })
        
        storeCollection.collectionViewLayout = layout
    }
    
    private func clearSnapshot() {
        product?.removeAll()
        fyp.removeAll()
        snapshot.deleteAllItems()
        if !snapshot.sectionIdentifiers.isEmpty {
            snapshot.deleteSections(collections)
        }
        storeCollection.hideSkeleton(reloadDataAfter: false)
        dataSource.apply(snapshot, animatingDifferences: true)
        self.errorView.removeFromSuperview()
    }
    
    @objc private func navigateToSearch() {
        let vc = SearchProductViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func navigateToCart() {
        let vc = CartViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func refreshData() {
        clearSnapshot()
        vm.fetchProduct()
        vm.fetchCategories()
    }
}

extension StoreViewController: UICollectionViewDelegate {
    internal func navigateToDetail(index: Int) {
        if let productID = product?[index].id {
            let vc = DetailProductViewController()
            vc.id = productID
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 2 {
            let index = indexPath.item
            navigateToDetail(index: index)
        }
    }
    
    private func updateCarouselSectionVisibility() {
        guard let collectionView = storeCollection.collectionViewLayout.collectionView else { return }
        
        let carouselSectionIndex = SectionStoreCollection.carousel.rawValue
        let isCarouselVisible = collectionView.indexPathsForVisibleItems.contains { indexPath in
            return indexPath.section == carouselSectionIndex
        }
        
        isCarouselSectionVisible = isCarouselVisible
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCarouselSectionVisibility()
    }
}
