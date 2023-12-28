//
//  SearchUserDataSource.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import SkeletonView

// MARK: - UICollectionViewDiffableDataSource class for implementing SkeletonView in SearchUserViewController
class SearchUserDataSource: UITableViewDiffableDataSource<SectionSearchUser, ListStory>, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: UserTableCell.self)
    }
}
