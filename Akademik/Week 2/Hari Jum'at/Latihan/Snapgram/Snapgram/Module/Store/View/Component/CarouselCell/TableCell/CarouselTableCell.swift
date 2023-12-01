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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        carouselCollection.delegate = self
        carouselCollection.dataSource = self
        carouselCollection.registerCellWithNib(CarouselCollectionCell.self)
    }
}

extension CarouselTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CarouselCollectionCell
        let carousel = carouselItem[indexPath.row]
        cell.configure(with: carousel)
        
        return cell
    }
}

extension CarouselTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: CarouselCollectionCell.self)
    }
}
