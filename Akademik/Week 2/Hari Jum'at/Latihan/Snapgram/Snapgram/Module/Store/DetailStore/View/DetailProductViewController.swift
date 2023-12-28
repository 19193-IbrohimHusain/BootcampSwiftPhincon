//
//  DetailProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

class DetailProductViewController: BaseViewController {
    // MARK: - Variables
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
    
    // MARK: - Lifecycles
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
    
    // MARK: - Functions
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
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        detailCollection.refreshControl = refreshControl
        detailCollection.contentInsetAdjustmentBehavior = .never
        detailCollection.delegate = self
        detailCollection.dataSource = self
        collections.forEach {
            detailCollection.registerCellWithNib($0.cellTypes)
            $0.registerHeaderFooterTypes(in: detailCollection)
        }
    }
    
    private func refreshData() {
        self.currentIndex = 0
        self.product = nil
        self.recommendation?.removeAll()
        vm.fetchProduct(param: ProductParam())
        vm.fetchDetailProduct(param: ProductParam(id: id, limit: nil))
        self.errorView.removeFromSuperview()
    }
}

// MARK: - Extension for UICollectionViewDelegate
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
