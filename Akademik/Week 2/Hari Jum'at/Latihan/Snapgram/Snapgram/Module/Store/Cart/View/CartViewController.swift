//
//  CartViewController.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

class CartViewController: BaseViewController {
    
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
        vm.fetchCartItems()
    }
    
    
    private func setup() {
        setupNavigationBar()
        cartTable.delegate = self
        cartTable.registerCellWithNib(CartTableCell.self)
        setupDataSource()
        bindData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.titleView = configureNavigationTitle(title: "Cart")
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: nil), animated: true)
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: cartTable) { [weak self] (tableView, indexPath, item) in
            guard let self = self else { return UITableViewCell() }
            let cell: CartTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let data = self.dataSource.itemIdentifier(for: indexPath) {
                cell.configure(with: data)
            }
            return cell
        }
    }
    
    private func bindData() {
        vm.cartItems.asObservable().subscribe(onNext: { [weak self] items in
            guard let self = self, let items = items else { return }
            self.loadSnapshot(item: items)
        }).disposed(by: bag)
    }
    
    private func loadSnapshot(item: [Cart]) {
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
