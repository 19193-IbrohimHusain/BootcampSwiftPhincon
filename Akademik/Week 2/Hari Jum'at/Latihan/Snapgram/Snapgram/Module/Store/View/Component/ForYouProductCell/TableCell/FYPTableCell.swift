//
//  FYPTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

protocol FYPTableCellDelegate {
    func navigateToDetail()
}

class FYPTableCell: UITableViewCell {

    @IBOutlet weak var fYPCollection: UICollectionView!
    
    internal var delegate: FYPTableCellDelegate?
    private var product: [ProductModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        fYPCollection.delegate = self
        fYPCollection.dataSource = self
        fYPCollection.registerCellWithNib(FYPCollectionCell.self)
    }

    internal func configure(data: [ProductModel]) {
        self.product = data
        fYPCollection.reloadData()
    }
}

extension FYPTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FYPCollectionCell
        if let fYPProduct = product?[indexPath.row] {
            cell.configure(with: fYPProduct)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateToDetail()
    }
}

extension FYPTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: FYPCollectionCell.self)
    }
}
