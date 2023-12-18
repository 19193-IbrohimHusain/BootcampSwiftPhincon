//
//  DetailProductDatasource.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation
import SkeletonView

class DetailProductDataSource: UICollectionViewDiffableDataSource<SectionDetailProduct, ProductModel>, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: FYPCollectionCell.self)
    }
}

