//
//  CartViewController.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartTable: UITableView!
    
    var snapshot = NSDiffableDataSourceSnapshot<SectionCartTable, CartModel>()
    var dataSource: UITableViewDiffableDataSource<SectionCartTable, CartModel>!
    var cartItem: [CartModel] = [
        CartModel(productID: 1, name: "Adidas", price: 200, quantity: 1, image: "Blank Image"),
        CartModel(productID: 2, name: "Nike", price: 200, quantity: 1, image: "Blank Image"),
        CartModel(productID: 3, name: "Puma", price: 200, quantity: 1, image: "Blank Image"),
        CartModel(productID: 4, name: "Balenciaga", price: 200, quantity: 1, image: "Blank Image"),
        CartModel(productID: 5, name: "NewBalance", price: 200, quantity: 1, image: "Blank Image")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup() {
        cartTable.delegate = self
        cartTable.registerCellWithNib(CartTableCell.self)
        setupDataSource()
        loadSnapshot()
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
    
    private func loadSnapshot() {
        snapshot.appendSections([.main])
        snapshot.appendItems(cartItem)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
