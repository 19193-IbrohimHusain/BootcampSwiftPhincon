//
//  NewArrivalTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

protocol NATableCellDelegate {
    func navigateToDetail(id: Int)
}

class NATableCell: UITableViewCell {

    @IBOutlet weak var nACollection: UICollectionView!
    
    internal var delegate: NATableCellDelegate?
    private var product: [ProductModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        nACollection.delegate = self
        nACollection.dataSource = self
        nACollection.registerCellWithNib(NACollectionCell.self)
    }

    internal func configure(data: [ProductModel]) {
        self.product = data
        nACollection.reloadData()
    }
    
//    private func
}

extension NATableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NACollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if let nAProduct = product?[indexPath.item] {
            cell.configure(with: nAProduct)
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

extension NATableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: NACollectionCell.self)
    }
}
