//
//  SectionPostCollection.swift
//  Snapgram
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import UIKit

enum SectionPostCollection: Int, CaseIterable {
    case post, tagged
    
    internal var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .post:
            return PostCollectionCell.self
        case .tagged:
            return TaggedPostCollectionCell.self
        }
    }
}
