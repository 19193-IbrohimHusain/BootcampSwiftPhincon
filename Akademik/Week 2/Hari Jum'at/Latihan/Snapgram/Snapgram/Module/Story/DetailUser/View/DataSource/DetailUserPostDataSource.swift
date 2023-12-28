//
//  DetailUserPostDataSource.swift
//  Snapgram
//
//  Created by Phincon on 20/12/23.
//

import Foundation
import UIKit
import SkeletonView

// MARK: - UICollectionViewDiffableDataSource class for implementing SkeletonView in DetailUserPostCollection
class DetailUserPostDataSource: UICollectionViewDiffableDataSource<SectionDetailUserPost, ListStory>, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: UserPostCell.self)
    }
}
