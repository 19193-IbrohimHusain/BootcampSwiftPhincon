//
//  CartViewController.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

class CartViewController: BaseViewController {
    
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cartTable: UITableView!
    
    var vm = CartViewModel()
    var snapshot = NSDiffableDataSourceSnapshot<SectionCartTable, Cart>()
    var dataSource: UITableViewDiffableDataSource<SectionCartTable, Cart>!
    
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
        clearSnapshot()
    }
    
    
    private func setup() {
        setupNavigationBar()
        setupTable()
        setupDataSource()
        bindData()
        btnEvent()
    }
    
    private func setupTable() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { self.refreshData() }).disposed(by: bag)
        cartTable.refreshControl = refreshControl
        cartTable.delegate = self
        cartTable.registerCellWithNib(CartTableCell.self)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.titleView = configureNavigationTitle(title: "Cart")
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(navigateToWishlist)), animated: true)
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: cartTable) { [weak self] (tableView, indexPath, item) in
            guard let self = self else { return UITableViewCell() }
            let cell: CartTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.indexPath = indexPath
            if let data = self.dataSource.itemIdentifier(for: indexPath) {
                cell.configure(with: data)
            }
            return cell
        }
    }
    
    private func bindData() {
        vm.cartItems.asObservable().subscribe(onNext: { [weak self] items in
            guard let self = self, let items = items else { return }
            self.refreshControl.endRefreshing()
            self.loadSnapshot(item: items)
        }).disposed(by: bag)
    }
    
    private func btnEvent() {
        buyBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.displayAlert(title: "Apologies!", message: "This feature is coming soon~")
        }).disposed(by: bag)
        
        selectAllBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.displayAlert(title: "Apologies!", message: "This feature is coming soon~")
        }).disposed(by: bag)
    }
    
    private func loadSnapshot(item: [Cart]) {
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(item)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    internal func addItemToCoreData(for action: ProductCoreData, indexPath: IndexPath) -> CoreDataResult {
        guard let user = try? BaseConstant.getUserFromUserDefaults(), let item = self.dataSource.itemIdentifier(for: indexPath), let imageUrl = item.image, let name = item.name else { return .failed }
        switch action {
        case .favorite(let entity):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": item.productID,
                "name": name,
                "imageLink": imageUrl,
                "price": item.price,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(FavoriteProducts.self, for: .favorite(id: entity), productId: Int(item.productID), userId: user.userid, properties: properties)
        default: break
        }
        return .failed
    }
    
    internal func resultHandler(for state: CoreDataResult, destination: String, item: Cart) {
        switch state {
        case .added:
            self.displayAlert(title: "Success", message: "Item Added To \(destination)", action: self.addAlertAction) {
                self.clearSnapshot() { self.vm.fetchCartItems() }
            }
        case .failed:
            self.displayAlert(title: "Failed", message: "Failed To Add Item")
        case .deleted:
            self.displayAlert(title: "Success", message: "Item Deleted From \(destination)", action: destination == "Wishlist" ? self.addAlertAction : nil) {
                self.clearSnapshot() { self.vm.fetchCartItems() }
            }
        case .updated:
            self.displayAlert(title: "Success", message: "Item Added To \(destination)", action: self.addAlertAction) {
                self.clearSnapshot() { self.vm.fetchCartItems() }
            }
        }
    }
    
    private func addAlertAction() -> UIAlertAction {
        let navigateToCartAction = UIAlertAction(title: "See Wishlist", style: .default) { _ in
            let vc = WishlistViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return navigateToCartAction
    }
    private func clearSnapshot(completion: (() -> Void)? = nil) {
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: false) { completion?() }
    }
    
    private func refreshData() {
        clearSnapshot()
        vm.fetchCartItems()
    }
    
    @objc private func navigateToWishlist() {
        let vc = WishlistViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailProductViewController()
        if let item = dataSource.itemIdentifier(for: indexPath) {
            vc.id = Int(item.productID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CartViewController: CartTableCellDelegate {
    func incrementQty(index: IndexPath) {
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        if let item = dataSource.itemIdentifier(for: index) {
            weak let _ = CoreDataHelper.shared.updateItemQty(Cart.self, productID: item.productID, userId: user.userid)
            clearSnapshot() { self.vm.fetchCartItems() }
        }
    }
    
    func decrementQty(index: IndexPath) {
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        if let item = dataSource.itemIdentifier(for: index) {
            let state = CoreDataHelper.shared.updateItemQty(Cart.self, productID: item.productID, userId: user.userid, isIncrement: false)
            if state == .deleted {
                self.resultHandler(for: state, destination: "Cart", item: item)
            } else {
                clearSnapshot() { self.vm.fetchCartItems() }
            }
        }
    }
    
    func addWishlist(index: IndexPath) {
        if let item = self.dataSource.itemIdentifier(for: index) {
            let state = self.addItemToCoreData(for: .favorite(id: Int(item.productID)), indexPath: index)
            self.resultHandler(for: state, destination: "Wishlist", item: item)
        }
    }
    
    func isExist(index: IndexPath) -> Bool {
        guard !snapshot.itemIdentifiers.isEmpty, let user = try? BaseConstant.getUserFromUserDefaults() else { return false }
        let item = snapshot.itemIdentifiers[index.item]
        let result = CoreDataHelper.shared.isEntityExist(FavoriteProducts.self, productId: Int(item.productID), userId: user.userid)
        return result
    }
}
