//
//  DetailProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

class DetailProductViewController: BaseViewController {
    
    @IBOutlet weak var detailCollection: UICollectionView!
    
    internal let collections = SectionDetailProduct.allCases
    internal let vm = DetailProductViewModel()
    internal var id: Int?
    internal var currentIndex = 0
    internal var timer: Timer?
    internal var product: ProductModel?
    internal var image: [GalleryModel]?
    internal var recommendation: [ProductModel]?
    internal var layout: UICollectionViewCompositionalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = id {
            vm.fetchDetailProduct(param: ProductParam(id: id, limit: nil))
            vm.fetchProduct()
        }
    }
    
    private func setup() {
        setupNavigationBar()
        setupCollection()
        setupErrorView()
        setupCompositionalLayout()
        bindData()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.backButtonTitle = nil
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupCollection() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        detailCollection.refreshControl = refreshControl
        detailCollection.contentInsetAdjustmentBehavior = .never
        detailCollection.delegate = self
        detailCollection.dataSource = self
        collections.forEach {
            detailCollection.registerCellWithNib($0.cellTypes)
            $0.registerHeaderFooterTypes(in: detailCollection)
        }
    }
    
    @objc private func refreshData() {
        self.currentIndex = 0
        self.product = nil
        self.recommendation?.removeAll()
        vm.fetchProduct(param: ProductParam())
        vm.fetchDetailProduct(param: ProductParam(id: id, limit: nil))
        self.errorView.removeFromSuperview()
    }
}

extension DetailProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = SectionDetailProduct(rawValue: section)
        switch section {
        case .image:
            return  image?.count ?? 3
        case .name, .desc:
            return 1
        case .recommendation:
            return  recommendation?.count ?? 3
        default: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = SectionDetailProduct(rawValue: indexPath.section)
        switch section {
        case .image:
            let cell: ImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let image = image?[indexPath.item] {
                cell.configure(with: image)
                cell.hideSkeleton()
            }
            return cell
        case .name:
            let cell1: NameCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = product {
                cell1.configure(with: product)
            }
            return cell1
        case .desc:
            let cell2: DescriptionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = product {
                cell2.configure(with: product)
            }
            return cell2
        case .recommendation:
            let cell3: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = recommendation?[indexPath.item] {
                cell3.configure(with: product)
                cell3.hideSkeleton()
            }
            return cell3
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = SectionDetailProduct(rawValue: indexPath.section)
        switch section {
            case .image:
                let footer: ImageFooter = collectionView.dequeueHeaderFooterCell(
                    kind: UICollectionView.elementKindSectionFooter,
                    forIndexPath: indexPath
                )
                footer.subscribeTo(subject: vm.imagePaging, for: collections[0].rawValue)
                currentIndex = footer.pageControl.currentPage
                return footer
            case .recommendation:
                let header: RecommendationHeader = collectionView.dequeueHeaderFooterCell(
                    kind: UICollectionView.elementKindSectionHeader,
                    forIndexPath: indexPath
                )
                return header
            default: return UICollectionReusableView()
        }
    }
}

extension DetailProductViewController: UICollectionViewDelegate {
    private func navigateToDetail(index: Int) {
        if let productID = recommendation?[index].id {
            let vc = DetailProductViewController()
            vc.id = productID
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 3 else { return }
        let index = indexPath.item
        navigateToDetail(index: index)
    }
}
