//
//  PopularTableCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import SkeletonView

protocol PopularTableCellDelegate {
    func navigateToDetail()
}

class PopularTableCell: UITableViewCell {

    @IBOutlet weak var popularCollection: UICollectionView!
    
    internal var delegate: PopularTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        popularCollection.delegate = self
        popularCollection.dataSource = self
        popularCollection.registerCellWithNib(PopularCollectionCell.self)
    }
}

extension PopularTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PopularCollectionCell
        let popularItem = carouselItem[indexPath.row]
        cell.configure(with: popularItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateToDetail()
    }
}

extension PopularTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: PopularCollectionCell.self)
    }
}
