//
//  DetailUserViewDataSource.swift
//  Snapgram
//
//  Created by Phincon on 20/12/23.
//

import Foundation
import UIKit
import SkeletonView

// MARK: - UICollectionViewDiffableDataSource class for implementing SkeletonView in DetailUserViewController
class DetailUserDataSource: UICollectionViewDiffableDataSource<SectionDetailUser, ListStory>, SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return SectionDetailUser.allCases.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = SectionDetailUser(rawValue: section)
        switch section {
        case .profile, .post:
                return 1
            default: return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let collection = SectionDetailUser(rawValue: indexPath.section)
        guard let section = collection else { return "" }
        
        if let identifier = SectionDetailUser.sectionIdentifiers[section] {
            return identifier
        } else {
            return ""
        }
    }
}
