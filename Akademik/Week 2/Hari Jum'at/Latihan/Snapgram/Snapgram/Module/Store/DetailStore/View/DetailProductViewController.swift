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
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    
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
        btnEvent()
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
    
    private func btnEvent() {
        chatBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
        }).disposed(by: bag)
        addToCartBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self, let product = self.product else { return }
            self.addLoading(self.addToCartBtn)
            let state = CoreDataHelper.shared.saveItemToCart(data: product)
            state ? self.displayAlert(title: "Success", message: "Item Added To Cart") : self.displayAlert(title: "Failed", message: "Failed To Add Item")
            self.afterDissmissed(self.addToCartBtn, title: "Add to cart")
            
        }).disposed(by: bag)
    }
    
    private func addItemToCoreData(for action: ProductCoreData) -> Bool {
        guard let user = try? BaseConstant.getUserFromUserDefaults(), let product = self.product, let image = self.image?.first else { return false }
        switch action {
        case .cart(let entity):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(product.id),
                "name": product.name,
                "image": image.url,
                "price": product.price,
                "quantity": 1,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(Cart.self, for: .cart(entity: entity), userId: user.userid, properties: properties)
        case .favorite(let entity):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(product.id),
                "name": product.name,
                "image": image.url,
                "price": product.price,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(FavoriteProducts.self, for: .favorite(entity: entity), userId: user.userid, properties: properties)
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

extension DetailProductViewController: NameCellDelegate {
    func addFavorite() {
        if let product = self.product {
            let state = CoreDataHelper.shared.addFavoriteProduct(data: product)
            state ? self.displayAlert(title: "Success", message: "Item Added To Favorite") : self.displayAlert(title: "Failed", message: "Failed To Add Item")
        }
    }
    
    func checkIsFavorite() -> Bool {
        guard let product = self.product else { return false }
        return CoreDataHelper.shared.isFavProductExist(id: Int16(product.id))
    }
    
    
}
