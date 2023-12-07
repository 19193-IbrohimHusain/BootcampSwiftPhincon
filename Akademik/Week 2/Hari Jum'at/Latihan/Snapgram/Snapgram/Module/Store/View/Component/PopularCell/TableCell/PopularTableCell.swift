//
//  PopularTableCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import SkeletonView

protocol PopularTableCellDelegate {
    func navigateToDetail(id: Int)
}

class PopularTableCell: UITableViewCell {

    @IBOutlet weak var popularCollection: UICollectionView!
    
    internal var delegate: PopularTableCellDelegate?
    private var product: [ProductModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        popularCollection.delegate = self
        popularCollection.dataSource = self
        popularCollection.registerCellWithNib(PopularCollectionCell.self)
    }
    
    internal func configure(data: [ProductModel]) {
        self.product = data
        popularCollection.reloadData()
    }
}

extension PopularTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PopularCollectionCell
        if let popularItem = product?[indexPath.item] {
            cell.configure(with: popularItem)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let productID = product?[index].id {
            self.delegate?.navigateToDetail(id: productID)
        }
    }
}

extension PopularTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: PopularCollectionCell.self)
    }
}
