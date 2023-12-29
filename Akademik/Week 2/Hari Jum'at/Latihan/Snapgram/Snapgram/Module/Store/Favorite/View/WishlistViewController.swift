//
//  FavoriteProductViewController.swift
//  Snapgram
//
//  Created by Phincon on 29/12/23.
//

import UIKit

class WishlistViewController: BaseViewController {

    @IBOutlet weak var favTable: UITableView!
    
    var vm = WishlistViewModel()
    var snapshot = NSDiffableDataSourceSnapshot<SectionCartTable, FavoriteProducts>()
    var dataSource: UITableViewDiffableDataSource<SectionCartTable, FavoriteProducts>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchFavProduct()
    }
    
    private func setup(){
        setupNavigationBar()
        setupTable()
        setupDataSource()
        bindData()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.titleView = configureNavigationTitle(title: "Wishlist")
    }
    
    private func setupTable() {
        favTable.delegate = self
        favTable.registerCellWithNib(WishlistTableCell.self)
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: favTable) { (tableView, indexPath, item) in
            let cell: WishlistTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(with: item)
            return cell
        }
    }
    
    private func bindData() {
        vm.favProduct.asObservable().subscribe(onNext: { [weak self] items in
            guard let self = self, let items = items else { return }
            self.loadSnapshot(item: items)
        }).disposed(by: bag)
    }
    
    private func loadSnapshot(item: [FavoriteProducts]) {
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete"){ _,_,_ in
            let item = self.snapshot.itemIdentifiers[indexPath.row]
            self.snapshot.deleteItems([item])
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
            CoreDataHelper.shared.deleteFavProduct(id: item.productID)
        }])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
}
