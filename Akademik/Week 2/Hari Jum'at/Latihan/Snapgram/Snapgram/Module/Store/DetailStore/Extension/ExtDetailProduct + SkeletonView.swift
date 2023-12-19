//
//  ExtDetailProduct + SkeletonView.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation
import SkeletonView

extension DetailProductViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collection = SectionDetailProduct(rawValue: section)
        switch collection {
        case .image:
            return image?.count ?? 1
        case .name,.desc:
            return 1
        case .recommendation:
            return recommendation?.count ?? 2
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let collection = SectionDetailProduct(rawValue: indexPath.section)
        guard let section = collection else { return "" }
        
        if let identifier = SectionDetailProduct.sectionIdentifiers[section] {
            return identifier
        } else {
            return ""
        }
    }
}
