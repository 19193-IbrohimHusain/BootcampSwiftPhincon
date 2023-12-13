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
    private var category: [CategoryModel]?
    private var fyp: [ProductModel] = []
    private var timer: Timer?
    private var currentIndex = 0
    private var isCarouselSectionVisible: Bool?
    private var fypSectionHeight: CGFloat?
    private var headerFYP: UICollectionView!
    private var snapshot = NSDiffableDataSourceSnapshot<SectionStoreCollection, ProductModel>()
    private var dataSource: UICollectionViewDiffableDataSource<SectionStoreCollection, ProductModel>!
    private var layout: UICollectionViewCompositionalLayout!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    private func setup() {
        setupNavigationBar(title: "SnapStore", image1: "line.horizontal.3", image2: "cart", action1: nil, action2: nil)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storeCollection.refreshControl = refreshControl
        storeCollection.delegate = self
        collections.forEach {
            storeCollection.registerCellWithNib($0.cellTypes)
            $0.registerHeaderFooterTypes(collectionView: storeCollection)
        }
        setupDataSource()
        bindData()
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: storeCollection) { [weak self] (collectionView, indexPath, product) in
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
                let cell3: FYPCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell3.bindData(data: self.fyp)
                cell3.delegate = self
                
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
                    header.delegate = self
                    if let category = self.category {
                        header.configure(data: category)
                    }
                    return header
                default: return nil
            }
        }
    }
    
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self, let section = SectionStoreCollection(rawValue: sectionIndex) else { fatalError("Invalid section index") }
            
            switch section {
            case .search:
                return NSCollectionLayoutSection.searchSection()
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
    
    private func loadSnapshot() {
        // append sections to snapshot
        snapshot.appendSections(collections)
        
        // append item to snapshot
        if let product = product {
            // append item to section search
            if var section1 = product.first {
                section1.cellTypes = .search
                snapshot.appendItems([section1], toSection: .search)
            }
            
            // append item to section carousel
            let section2 = product.prefix(5).map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .carousel
                return modifiedItem
            }
            snapshot.appendItems(section2, toSection: .carousel)
            
            // append item to section popular
            let section3 = product.prefix(9).map {
                var modifiedItem = $0
                modifiedItem.cellTypes = .popular
                return modifiedItem
            }
            snapshot.appendItems(section3, toSection: .popular)
            
            // append item to section fyp
            if var section4 = product.first {
                section4.cellTypes = .forYouProduct
                snapshot.appendItems([section4], toSection: .forYouProduct)
            }
        }
        // apply snapshot to datasource
        dataSource.apply(snapshot, animatingDifferences: true)
        setupCompositionalLayout()
    }
    
    private func bindData() {
        vm.productData.asObservable().subscribe(onNext: { [weak self] product in
            guard let self = self, var dataProduct = product else {return}
            dataProduct.remove(at: 0)
            self.product = dataProduct
            self.fyp.append(contentsOf: dataProduct)
            dataProduct.forEach {
                var modifiedItems = $0
                modifiedItems.id += 14
                self.fyp.append(modifiedItems)
            }
            self.startTimer()
        }).disposed(by: bag)
        
        vm.sportShoes.asObservable().subscribe(onNext: {[weak self] product in
            guard let self = self, let dataProduct = product else {return}
            dataProduct.forEach {
                var modifiedItem = $0
                modifiedItem.id += 29
                self.fyp.append(modifiedItem)
                self.loadSnapshot()
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
    
    private func scrollToMenuIndex(index: Int) {
        let sectionIndex = IndexPath(row: 0, section: 3)
        if let cell = storeCollection.cellForItem(at: sectionIndex) as? FYPCollectionViewCell {
            cell.fypCollection.scrollToItem(at: IndexPath(item: 0, section: index), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func startTimer() {
        isCarouselSectionVisible = true
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    private func updateCarouselSectionVisibility() {
        guard let collectionView = storeCollection.collectionViewLayout.collectionView else { return }

        let carouselSectionIndex = SectionStoreCollection.carousel.rawValue
        let isCarouselVisible = collectionView.indexPathsForVisibleItems.contains { indexPath in
            return indexPath.section == carouselSectionIndex
        }

        isCarouselSectionVisible = isCarouselVisible
    }
    
    @objc private func timerAction() {
        guard let isVisible = isCarouselSectionVisible, let product = product?.prefix(5), isVisible else { return }
        currentIndex =  (currentIndex + 1) % (product.count)
        storeCollection.scrollToItem(at: IndexPath(item: currentIndex, section: 1), at: .centeredHorizontally, animated: true)
    }
    
    @objc func refreshData() {
        product?.removeAll()
        snapshot.deleteAllItems()
        snapshot.deleteSections(collections)
        dataSource.apply(snapshot, animatingDifferences: true)
        vm.fetchProduct()
        vm.fetchCategories()
    }
}

extension StoreViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCarouselSectionVisibility()
    }
}

extension StoreViewController: SearchCollectionCellDelegate {
    func search() {
        self.dataSource
    }
}

extension StoreViewController: FYPCollectionViewCellDelegate {
    func didScroll(scrollView: UIScrollView) {
        // MARK: Not fix yet
        let itemIndex = Int(scrollView.contentOffset.x / view.frame.width)
        let indexPath = IndexPath(item: itemIndex, section: 0)
        if let headerFYP = self.headerFYP {
            headerFYP.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
    }
    
    func sendHeight(height: CGFloat) {
        self.fypSectionHeight = height
    }
}

extension StoreViewController: FYPHeaderDelegate {
    func setCurrentSection(index: Int, collectionView: UICollectionView) {
        self.headerFYP = collectionView
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
