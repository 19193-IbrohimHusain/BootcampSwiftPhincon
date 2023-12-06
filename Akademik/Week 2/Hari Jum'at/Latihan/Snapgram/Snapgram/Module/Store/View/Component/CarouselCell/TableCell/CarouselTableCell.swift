//
//  CarouselTableCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import SkeletonView

class CarouselTableCell: UITableViewCell {

    @IBOutlet weak var carouselCollection: UICollectionView!
    
    private var product: [ProductModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        carouselCollection.delegate = self
        carouselCollection.dataSource = self
        carouselCollection.registerCellWithNib(CarouselCollectionCell.self)
    }
    
    internal func configure(data: [ProductModel]) {
        self.product = data
        carouselCollection.reloadData()
    }
}

extension CarouselTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CarouselCollectionCell
        let item = product?[indexPath.item]
        item?.galleries?.forEach { carousel in
            cell.configure(with: carousel)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        carouselCollection.scrollToNearestVisibleCollectionViewCell()
    }
}

extension CarouselTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: CarouselCollectionCell.self)
    }
}
