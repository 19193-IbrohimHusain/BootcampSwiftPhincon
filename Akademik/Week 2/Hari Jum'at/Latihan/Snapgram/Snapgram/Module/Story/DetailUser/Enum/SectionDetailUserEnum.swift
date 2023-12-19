//
//  SectionDetailUserEnum.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

enum SectionDetailUser: Int, CaseIterable {
    case profile, category, post
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .profile:
            return DetailUserProfileCell.self
        case .category:
            return DetailUserCategoryCell.self
        case .post:
            return DetailUserPostCell.self
        }
    }
}
