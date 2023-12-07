//
//  DetailImageTableCell.swift
//  Snapgram
//
//  Created by Phincon on 29/11/23.
//

import UIKit
import SkeletonView

class DetailImageTableCell: UITableViewCell {

    @IBOutlet weak var dICollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        dICollection.delegate = self
        dICollection.dataSource = self
        dICollection.registerCellWithNib(DetailImageCollectionCell.self)
    }
}

extension DetailImageTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailImageCollectionCell
        let image = carouselItem[indexPath.row]
        cell.configure(with: image)
        
        return cell
    }
}

extension DetailImageTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: DetailImageCollectionCell.self)
    }
}
