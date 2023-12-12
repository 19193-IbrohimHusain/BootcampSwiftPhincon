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
    private var popular: [ProductModel]?
    private var category: [CategoryModel]?
    private var fyp: [ProductModel] = []
    private var timer: Timer?
    private var currentIndex = 0
    private var loadedIndex: Int = 5
    private var isLoadMoreData = false
    private var snapshot = NSDiffableDataSourceSnapshot<SectionStoreCollection, ProductModel>()
    private var dataSource: UICollectionViewDiffableDataSource<SectionStoreCollection, ProductModel>!
    private var layout: UICollectionViewCompositionalLayout!
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func setup() {
        setupNavigationBar(title: "SnapStore", image1: "line.horizontal.3", image2: "cart", action1: nil, action2: nil)
        let layoutGuide = view.safeAreaLayoutGuide
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8)
        ])
        loadingIndicator.hidesWhenStopped = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storeCollection.refreshControl = refreshControl
        storeCollection.delegate = self
        storeCollection.allowsFocus = false
        collections.forEach {
            storeCollection.registerCellWithNib($0.cellTypes)
            $0.registerHeaderFooterTypes(collectionView: storeCollection)
        }
        setupDataSource()
        setupCompositionalLayout()
        bindData()
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: storeCollection) { [weak self] collectionView, indexPath, product in
            guard let self = self else { return UICollectionViewCell()}
            switch product.cellTypes {
            case .search:
                let cell: SearchCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.searchInputField.textField
                
                return cell
            case .carousel:
                let cell1: CarouselCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let item = self.dataSource.itemIdentifier(for: indexPath) {
                    item.galleries?.forEach {
                        cell1.configure(with: $0)
                        cell1.isSkeletonable = true
                    }
                }
                return cell1
            case .popular:
                let cell2: PopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                if let item = self.dataSource.itemIdentifier(for: indexPath) {
                    cell2.configure(with: item)
                    cell2.isSkeletonable = true
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
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self, let section = SectionStoreCollection(rawValue: indexPath.section) else { return UICollectionReusableView() }
            switch section {
                case .carousel:
                    let footer: CarouselFooter = collectionView.dequeueHeaderFooterCell(kind: UICollectionView.elementKindSectionFooter, forIndexPath: indexPath)
                    footer.subscribeTo(subject: self.vm.pagingCarousel, for: self.collections[1].rawValue)
                    return footer
                case .popular:
                    if kind == UICollectionView.elementKindSectionHeader {
                        let header: PopularHeader = collectionView.dequeueHeaderFooterCell(kind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
                        return header
                    } else {
                        let footer: PopularFooter = collectionView.dequeueHeaderFooterCell(kind: UICollectionView.elementKindSectionFooter, forIndexPath: indexPath)
                        footer.subscribeTo(subject: self.vm.pagingPopular, for: self.collections[2].rawValue)
                        return footer
                    }
                case .forYouProduct:
                    let header: FYPHeader = collectionView.dequeueHeaderFooterCell(kind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
//                    header.delegate = self
                    if let category = self.category {
                        header.configure(data: category)
                    }
                    return header
                default: return nil
            }
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] sectionIndex, env in
            guard let self = self, let product = self.product, let section = SectionStoreCollection(rawValue: sectionIndex) else { fatalError("Invalid section index") }
            
            switch section {
            case .search:
                return NSCollectionLayoutSection.searchSection()
            case .carousel:
                return NSCollectionLayoutSection.carouselSection(pagingInfo: self.vm.pagingCarousel)
            case .popular:
                return NSCollectionLayoutSection.popularListSection(pagingInfo: self.vm.pagingPopular)
            case .forYouProduct:
                return NSCollectionLayoutSection.createFYPLayout(env: env, items: product)
            }
        })
        
        storeCollection.collectionViewLayout = layout
    }
    
    private func reloadSnapshot() {
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
            
            let section4 = fyp.prefix(loadedIndex).map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .forYouProduct
                return modifiedItem
            }
            
            snapshot.appendItems(section2, toSection: .carousel)
            snapshot.appendItems(section3, toSection: .popular)
            snapshot.appendItems(section4, toSection: .forYouProduct)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, var dataProduct = product else {return}
            dataProduct.remove(at: 0)
            self.product = dataProduct
            self.fyp.append(contentsOf: dataProduct)
            self.reloadSnapshot()
            self.startTimer()
        }).disposed(by: bag)
        
        vm.runningShoes.asObservable().subscribe(onNext: {[weak self] product in
            guard let self = self, let dataProduct = product else {return}
            dataProduct.forEach {
                var modifiedItem = $0
                modifiedItem.id += 14
                self.fyp.append(modifiedItem)
            }
        }).disposed(by: bag)
        
        vm.trainingShoes.asObservable().subscribe(onNext: {[weak self] product in
            guard let self = self, let dataProduct = product else {return}
            dataProduct.forEach {
                var modifiedItem = $0
                modifiedItem.id += 14
                self.fyp.append(modifiedItem)
            }
        }).disposed(by: bag)
        
        vm.basketShoes.asObservable().subscribe(onNext: {[weak self] product in
            guard let self = self, let dataProduct = product else {return}
            dataProduct.forEach {
                var modifiedItem = $0
                modifiedItem.id += 14
                self.fyp.append(modifiedItem)
            }
        }).disposed(by: bag)
        
        vm.hikingShoes.asObservable().subscribe(onNext: {[weak self] product in
            guard let self = self, let dataProduct = product else {return}
            dataProduct.forEach {
                var modifiedItem = $0
                modifiedItem.id += 14
                self.fyp.append(modifiedItem)
            }
        }).disposed(by: bag)
        
        vm.sportShoes.asObservable().subscribe(onNext: {[weak self] product in
            guard let self = self, let dataProduct = product else {return}
            dataProduct.forEach {
                var modifiedItem = $0
                modifiedItem.id += 29
                self.fyp.append(modifiedItem)
            }
        }).disposed(by: bag)
        
        vm.categoryData.asObservable().subscribe(onNext: { [weak self] category in
            guard let self = self, let dataCategory = category else { return }
            self.category = dataCategory.reversed()
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.storeCollection.showAnimatedGradientSkeleton()
            case .finished:
                self.refreshControl.endRefreshing()
                self.storeCollection.hideSkeleton()
            case .failed:
                DispatchQueue.main.async {
                    self.storeCollection.hideSkeleton()
                    self.refreshControl.endRefreshing()
                    self.storeCollection.addSubview(self.errorView)
                }
            }
        }).disposed(by: bag)
    }
    
    private func loadMoreData() {
        // Fetch more items for the For You Product section
        guard let product = product, loadedIndex < fyp.count else {
            return // No more items to load
        }
        
        isLoadMoreData = true
        
        let moreItems = fyp[loadedIndex..<min(loadedIndex + 5, fyp.count)]
        let modifiedItems = moreItems.map {
            var modifiedItem = $0
            modifiedItem.cellTypes = .forYouProduct
            return modifiedItem
        }
        
        loadedIndex += 5 // Update the loaded index
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Update the snapshot with the newly loaded items
            self.snapshot.appendItems(modifiedItems, toSection: .forYouProduct)
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
            self.isLoadMoreData = false
            self.loadingIndicator.stopAnimating()
        }
        loadingIndicator.startAnimating()
    }
    
    private func scrollToMenuIndex(index: Int) {
        let index = IndexPath(row: 0, section: 3)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        currentIndex =  (currentIndex + 1) % (product?.prefix(5).count ?? 5)
        storeCollection.scrollToItem(at: IndexPath(item: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
    }
    
    @objc func refreshData() {
        loadedIndex = 5
        product?.removeAll()
        snapshot.deleteAllItems()
        snapshot.deleteSections(collections)
        dataSource.apply(snapshot, animatingDifferences: true)
        vm.fetchProduct()
        vm.fetchCategories()
    }
}

extension StoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collections[3].rawValue &&
            indexPath.item == dataSource.snapshot().itemIdentifiers(inSection: .forYouProduct).count - 1 {
            // Last item in the For You Product section is about to be displayed
            loadMoreData()
        }
    }
}

extension StoreViewController: SearchCollectionCellDelegate {
    func search() {
        self.dataSource
    }
}

extension StoreViewController: FYPHeaderDelegate {
    func setCurrentSection(index: Int) {
        self.scrollToMenuIndex(index: index)
    }
}


extension StoreViewController: CarouselTableCellDelegate, PopularTableCellDelegate, NATableCellDelegate, FYPTableCellDelegate {
    func navigateToDetail(id: Int) {
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoreViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = SectionStoreCollection(rawValue: indexPath.section)
        switch collection {
        case .search:
            let cell: SearchCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        case .carousel:
            let cell1: CarouselCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell1
        case .popular:
            let cell2: PopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell2
        case .forYouProduct:
            let cell3: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell3
        default: return UICollectionViewCell()
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let collection = SectionStoreCollection(rawValue: indexPath.section)
        guard let section = collection else { return "" }
        
        if let identifier = SectionStoreCollection.sectionIdentifiers[section] {
            return identifier
        } else {
            return ""
        }
    }
}
